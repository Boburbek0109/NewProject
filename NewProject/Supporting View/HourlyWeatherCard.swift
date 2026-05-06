//
//  HourlyWeatherCard.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/2/26.
//

import SwiftUI

struct HourlyWeatherCard: View{
    
    let hourlyWeather: TimeModel
    
    var body: some View{
        
        VStack(spacing: 8) {
            Text(hourlyWeather.formatHour)
                .font(.caption)
            
            Image(systemName: hourlyWeather.weatherSymbolNameDN(for: hourlyWeather.condition, at: hourlyWeather.date))
                .resizable()
                .scaledToFit()
                .frame(width: 34, height: 34)
            
            Text("\(Int(hourlyWeather.temperature.rounded()))°")
                .font(.headline)
        }
        .frame(width: 80, height: 120)
        .glassEffect(.clear, in: .rect(cornerRadius: 20))
    }
}
