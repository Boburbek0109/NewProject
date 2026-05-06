//
//  WeatherRow.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/25/26.
//

import SwiftUI

func WeatherRow(day: String, icon: String, title: String, high: Int, low: Int) -> some View{
    
    HStack{
        Text(day)
            .frame(width: 60, alignment: .leading)
        
        Image(systemName: icon)
            .resizable()
            .frame(width: 26, height: 32)
            .symbolRenderingMode(.multicolor)
//            .symbolEffect(.rotate, isActive: true)
        
        Text(title)
        
        Spacer()
        
        Text("\(high)° / \(low)°")
            .font(.body)
            .opacity(0.6)
        
    }
}

func weatherSymbolName(for condition: String?) -> String {
    guard let normalizedCondition = condition?.lowercased() else {
        return "cloud.sun.fill"
    }
    
    if normalizedCondition.contains("rain") || normalizedCondition.contains("drizzle") {
        return "cloud.rain.fill"
    }
    
    if normalizedCondition.contains("clear") || normalizedCondition.contains("sun") {
        return "sun.max.fill"
    }
    
    if normalizedCondition.contains("thunder") {
        return "cloud.bolt.rain.fill"
    }
    
    if normalizedCondition.contains("snow") {
        return "cloud.snow.fill"
    }
    
    if normalizedCondition.contains("cloud") {
        return "cloud.fill"
    }
    return "cloud.sun.fill"
}
