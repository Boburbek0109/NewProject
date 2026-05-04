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
        
        VStack(spacing: 10) {
            Text(hourlyWeather.formatHour)
            
            Image(systemName: hourlyWeather.weatherSymbolNameDN(for: hourlyWeather.condition, at: hourlyWeather.date))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text("\(Int(hourlyWeather.temperature.rounded()))°")
        }
        .frame(width: 90, height: 150)
        .glassEffect(.clear, in: .rect(cornerRadius: 20))
    }
}
