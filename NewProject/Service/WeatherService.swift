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

protocol WeatherProviding {
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData
}

final class WeatherService: WeatherProviding {
    
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
        
        
        var cityCalendar = Calendar.current
        cityCalendar.timeZone = TimeZone(secondsFromGMT: currentResponse.timezone) ?? .current
        
        
        let hourlyForecast: [TimeModel] = (0..<10).compactMap { offset in
            let forecastIndex = offset / 3
        
            guard forecastResponse.list.indices.contains(forecastIndex) else {
                return nil
            }
            
            let forecast = forecastResponse.list[forecastIndex]
            let date = Calendar.current.date(byAdding: .hour, value: offset, to: Date()) ?? Date()
            return TimeModel(
                date: date,
                temperature: forecast.main.temp,
                condiction: forecast.weather.first?.description,
                timezoneOffset: currentResponse.timezone
            )
            
        }

        
        let groupedForecast: [Date: [ForecastItem]] = Dictionary(grouping: forecastResponse.list) { item in
            cityCalendar.startOfDay(for: Date(timeIntervalSince1970: item.dt))
        }
        
        let sortedForecast = groupedForecast.sorted { first, second in
            first.key < second.key
        }
        
        let firstSevenForecast = sortedForecast.prefix(7)
        
        let dailyForecast: [DayWeather] = firstSevenForecast.map { entry in
            let date = entry.key
            let forecast = entry.value
            
            let highTemp = forecast.map { $0.main.tempMax}.max() ?? 0
            let lowTemp = forecast.map{ $0.main.tempMin}.min() ?? 0
            let condiction = forecast.first?.weather.first?.description ?? "Unknown"
            let humidity = forecast.map { $0.main.humidity}.reduce(0, +) / max(forecast.count, 1)
            let windSpeed = forecast.compactMap { $0.wind?.speed}.reduce(0, +) / Double(max(forecast.count, 1))
            let rainVolume = forecast
                .compactMap { $0.rain?.threeHour ?? $0.rain?.oneHour }
                .reduce(0, +)
            
            
            return DayWeather(
                date: date,
                condiction: condiction,
                highTemp: highTemp,
                lowTemp: lowTemp,
                humidity: humidity,
                windSpeed: windSpeed,
                rainVolume: rainVolume,
                timezoneOffset: currentResponse.timezone
                
            )
        }
        
        
        return WeatherData(
            locationName: currentResponse.name,
            temperature: currentResponse.main.temp,
            condiction: currentResponse.weather.first?.description ?? "Unknown",
            humidity: currentResponse.main.humidity,
            windSpeed: currentResponse.wind.speed,
            rainVolume: currentResponse.rain?.oneHour ?? 0,
            highTemp: currentResponse.main.tempMax,
            lowTemp: currentResponse.main.tempMin,
            hourlyForecast: hourlyForecast,
            dailyForecast: dailyForecast,
            timezoneOffset: currentResponse.timezone
        )
        
    }
}
