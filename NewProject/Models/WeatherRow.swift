//
//  WeatherRow.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/25/26.
//

import SwiftUI

struct DayWeather: Identifiable {
    let date: Date
    let condition: String
    let highTemp: Double
    let lowTemp: Double
    
    var id: Date { date }
    
    var formatDay: String{
        let formatDate = DateFormatter()
        formatDate.dateFormat = "EEE"
        return formatDate.string(from: date)
    }
}

func WeatherRow(day: String, icon: String, title: String, high: Int, low: Int) -> some View{
    
    return HStack{
        Text(day)
            .frame(width: 60, alignment: .leading)
        
        Image(systemName: icon)
            .resizable()
            .frame(width: 40, height: 40)
            .symbolRenderingMode(.multicolor)
        
        Text(title)
        
        Spacer()
        
        Text("\(high)° / \(low)°")
            .font(.body)
            .opacity(0.6)
        
    }
}

func weatherSymbolName(for condition: String?) -> String {
    let normalizedCondition = condition?.lowercased()
    guard let condition else {
        return "cloud.sun.fill"
    }
    
    if condition.contains("rain") || condition.contains("drizzle") {
        return "cloud.rain.fill"
    }
    
    if condition.contains("clear") || condition.contains("sun") {
        return "sun.max.fill"
    }
    
    if condition.contains("thunder") {
        return "cloud.bolt.rain.fill"
    }
    
    if condition.contains("snow") {
        return "cloud.snow.fill"
    }
    
    if condition.contains("cloud") {
        return "cloud.fill"
    }
    return "cloud.sun.fill"
}
