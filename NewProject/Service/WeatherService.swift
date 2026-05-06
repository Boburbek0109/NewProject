//
//  WeatherService.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/30/26.
//

import Foundation

enum WeatherServiceError: Error{
    case invalidURL
    case invalidResponse
}

final class WeatherService {
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
        let apiKey = "abc25637c8e72d3b22aec85adb7ef927"
        let forecastURLStr = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        let weatherURLStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        
        guard let forecastURL = URL(string: forecastURLStr),
              let weatherURL = URL(string: weatherURLStr) else {
            throw WeatherServiceError.invalidURL
        }
        
        async let forecastResult = URLSession.shared.data(from: forecastURL)
        async let weatherResult = URLSession.shared.data(from: weatherURL)
        
        let (forecastData, forecastURLResponse) = try await forecastResult
        let (weatherData, weatherURLResponse) = try await weatherResult
        
        guard let forecastHTTPResponse = forecastURLResponse as? HTTPURLResponse, 200..<300 ~= forecastHTTPResponse.statusCode,
              let weatherHTTPResponse = weatherURLResponse as? HTTPURLResponse, 200..<300 ~= weatherHTTPResponse.statusCode
        else {
            throw WeatherServiceError.invalidResponse
        }
        
        let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: forecastData)
        let currentResponse = try JSONDecoder().decode(CurrentWeatherResponse.self, from: weatherData)
        
        let hourlyForecast = (0..<10).map { offset in
            let forecastIndex = offset / 3
            let forecast = forecastResponse.list[forecastIndex]
            let date = Calendar.current.date(byAdding: .hour, value: offset, to: .now) ?? .now
            
            return TimeModel(
                date: date,
                temperature: forecast.main.temp,
                condition: forecast.weather.first?.description
            )
            
        }

        let calendar = Calendar.current
        let todayForecast = forecastResponse.list.filter {
            calendar.isDate(Date(timeIntervalSince1970: $0.dt), inSameDayAs: .now)
        }
        
        let dayForecasts = todayForecast.isEmpty ? forecastResponse.list : todayForecast
        let highTemp = dayForecasts.map(\.main.tempMax).max() ?? currentResponse.main.tempMax
        let lowTemp = dayForecasts.map(\.main.tempMin).min() ?? currentResponse.main.tempMin
        
        let dailyForecast = Dictionary(grouping: forecastResponse.list) { item in
            calendar.startOfDay(for: Date(timeIntervalSince1970: item.dt))
        }
        .sorted { $0.key < $1.key }
        .prefix(7)
        .map { date, forecasts in
            let highTemp = forecasts.map(\.main.tempMax).max() ?? 0
            let lowTemp = forecasts.map(\.main.tempMin).min() ?? 0
            let condition = forecasts.first?.weather.first?.description ?? "Unknown"
            let humidity = forecasts.map(\.main.humidity).reduce(0, +) / max(forecasts.count, 1)
            let windSpeed = forecasts.compactMap(\.wind?.speed).reduce(0, +) / Double(max(forecasts.count, 1))
            let rainVolume = forecasts
                .compactMap { $0.rain?.threeHour ?? $0.rain?.oneHour}
                .reduce(0, +)
            
            
            return DayWeather(
                date: date,
                condition: condition,
                highTemp: highTemp,
                lowTemp: lowTemp,
                humidity: humidity,
                windSpeed: windSpeed,
                rainVolume: rainVolume
            )
        }
        
        
        return WeatherData(
            locationName: currentResponse.name,
            temperature: currentResponse.main.temp,
            condition: currentResponse.weather.first?.description ?? "Unknown",
            humidity: currentResponse.main.humidity,
            windSpeed: currentResponse.wind.speed,
            rainVolume: currentResponse.rain?.oneHour ?? 0,
            highTemp: highTemp,
            lowTemp: lowTemp,
            hourlyForecast: hourlyForecast,
            dailyForecast: dailyForecast,
            timezoneOffset: currentResponse.timezone
        )
        
    }
}
