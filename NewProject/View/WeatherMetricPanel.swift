//
//  WeatherMetricPanel.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/6/26.
//

import SwiftUI

struct WeatherMetricPanel: View {
    let weatherData: WeatherData?
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .glassEffect(.clear, in: .rect(cornerRadius: 20))
                .frame(height: 120)
            
            HStack(spacing: 30){
                WeatherMetricView(iconName: weatherData?.iconName ?? "sun.max.fill", value: weatherData?.rainVolumeText ?? "0.0mm", title: "Rain")
                
                Divider()
                    .frame(height: 44)
                
                WeatherMetricView(iconName: "wind", value: weatherData?.windSpeedText ?? "0.0 km/h", title: "Wind\nSpeed")
                
                Divider()
                    .frame(height: 44)
                
                WeatherMetricView(iconName: "humidity", value: weatherData?.humidityText ?? "0%", title: "Humidity")
                
            }
        }
        .padding(.horizontal)
    }
}


#Preview{
    WeatherMetricPanel(weatherData: nil)
}
