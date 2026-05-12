//
//  WeatherData.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/4/26.
//

import Foundation

struct WeatherData: Identifiable {
    let id = UUID()
    let locationName: String
    let temperature: Double
    let condiction: String
    let humidity: Int
    let windSpeed: Double
    let rainVolume: Double
    let highTemp: Double
    let lowTemp: Double
    let hourlyForecast: [TimeModel]
    let dailyForecast: [DayWeather]
    let timezoneOffset: Int
    
}

extension WeatherData{
    func renamed(to locationName: String) -> WeatherData {
        WeatherData(locationName: locationName,
                    temperature: temperature,
                    condiction: condiction,
                    humidity: humidity,
                    windSpeed: windSpeed,
                    rainVolume: rainVolume,
                    highTemp: highTemp,
                    lowTemp: lowTemp,
                    hourlyForecast: hourlyForecast,
                    dailyForecast: dailyForecast,
                    timezoneOffset: timezoneOffset)
    }
    var iconName: String {
        TimeModel(
            date: Date(),
            temperature: temperature,
            condiction: condiction,
            timezoneOffset: timezoneOffset)
            .weatherSymbolNameDN(for: condiction, at: Date())
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
    
    var localDateText: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        formatter.dateFormat = "d MMM EEE | HH:mm"
        return formatter.string(from: Date())
    }
 }
