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
            
            return DayWeather(
                date: date,
                condition: condition,
                highTemp: highTemp,
                lowTemp: lowTemp
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
            dailyForecast: dailyForecast
        )
        
    }
    
}

struct WeatherData {
    let locationName: String
    let temperature: Double
    let condition: String
    let humidity: Int
    let windSpeed: Double
    let rainVolume: Double
    let highTemp: Double
    let lowTemp: Double
    let hourlyForecast: [TimeModel]
    let dailyForecast: [DayWeather]
    
}

extension WeatherData{
    var iconName: String {
        TimeModel(date: .now, temperature: temperature, condition: condition)
            .weatherSymbolNameDN(for: condition, at: .now)
    }

    var temperatureText: String {
        "\(Int(temperature.rounded()))°"
    }

    var humidityText: String {
        "\(humidity)%"
    }

    var windSpeedText: String {
        "\(windSpeed.formatted(.number.precision(.fractionLength(1)))) km/h"
    }

    var rainVolumeText: String {
        "\(rainVolume.formatted(.number.precision(.fractionLength(1)))) mm"
    }
    
    var highTempText: String{
        "H: \(Int(highTemp.rounded()))°"
    }
    
    var lowTempText: String{
        "L: \(Int(lowTemp.rounded()))°"
    }
 }

struct CurrentWeatherResponse: Decodable {
    let name: String
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: Wind
    let rain: Rain?
}

struct MainWeather: Decodable {
    let temp: Double
    let humidity: Int
    let tempMax: Double
    let tempMin: Double
    
    enum CodingKeys: String, CodingKey{
        case temp
        case humidity
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
    
}

struct WeatherCondition: Decodable {
    let description: String
}

struct Wind: Decodable{
    let speed: Double
}

struct Rain: Decodable{
    let oneHour: Double?
    let threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}


struct ForecastResponse: Decodable {
    let list: [ForecastItem]
    let city: ForecastCity
}

struct ForecastCity: Decodable{
    let name: String
}

struct ForecastItem: Decodable{
    let dt: TimeInterval
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: Wind?
    let rain: Rain?
}
