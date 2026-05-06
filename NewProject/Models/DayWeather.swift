//
//  DayWeather.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/4/26.
//

import Foundation

struct DayWeather: Identifiable {
    let date: Date
    let condition: String
    let highTemp: Double
    let lowTemp: Double
    let humidity: Int
    let windSpeed: Double
    let rainVolume: Double
    
    var id: Date { date }
    
    var formatDay: String{
        let formatDate = DateFormatter()
        formatDate.dateFormat = "EEE"
        return formatDate.string(from: date)
    }
    
    var iconName: String{
        weatherSymbolName(for: condition)
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
