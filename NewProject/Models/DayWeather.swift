//
//  DayWeather.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/4/26.
//

import Foundation

struct DayWeather: Identifiable {
    let date: Date
    let condiction: String
    let highTemp: Double
    let lowTemp: Double
    let humidity: Int
    let windSpeed: Double
    let rainVolume: Double
    let timezoneOffset: Int
    
    
    var id: Date { date }
    
    init(
        date: Date,
        condiction: String,
        highTemp: Double,
        lowTemp: Double,
        humidity: Int,
        windSpeed: Double,
        rainVolume: Double,
        timezoneOffset: Int = TimeZone.current.secondsFromGMT()
    ) {
        self.date = date
        self.condiction = condiction
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.rainVolume = rainVolume
        self.timezoneOffset = timezoneOffset
    }
    
    var formatDay: String{
        let formatDate = DateFormatter()
        formatDate.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        formatDate.dateFormat = "EEE"
        return formatDate.string(from: date)
    }
    
    var iconName: String{
        weatherSymbolName(for: condiction)
    }
    
    var temperatureText: String{
        "\(Int(highTemp.rounded()))°"
    }
    
    var humidityText: String{
        "\(humidity) %"
    }
    
    var windSpeedText: String{
        "\(windSpeed.formatted(.number.precision(.fractionLength(1)))) km/h"
    }
    
    var rainVolumeText: String{
        "\(rainVolume.formatted(.number.precision(.fractionLength(1)))) mm"
    }
}
