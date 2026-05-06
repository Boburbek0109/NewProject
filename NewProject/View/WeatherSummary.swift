//
//  WeatherSummary.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/5/26.
//

import SwiftUI

struct WeatherSummary: View{
    let weatherData: WeatherData?
    
    var body: some View{
        VStack(alignment: .center, spacing: 8) {
            
            Text(weatherData?.condition ?? "Loading weather...")
                .font(.title2)
            
            if let weatherData{
                Text(weatherData.locationName)
                    .font(.title3)
            }
            
            Image(systemName: weatherData?.iconName ?? "cloud.sun.fill")
                .symbolRenderingMode(.multicolor)
                .resizable()
                .scaledToFit()
                .frame(width: 82, height: 82)
            
            Text(weatherData?.localDateText ?? "--")
                .font(.subheadline)
            
            if let weatherData{
                Text(weatherData.temperatureText)
                    .font(.system(size: 54, weight: .semibold))
                    .frame(width: 130)
            } else {
                ProgressView()
            }
            
            
            HStack(spacing: 8) {
                Text(weatherData?.highTempText ?? "H: --")
                Text(weatherData?.lowTempText ?? "L: --")
            }
        }
    }
}

#Preview {
    WeatherSummary(weatherData: WeatherData(
        locationName: "Seoul",
        temperature: 24,
        condition: "clear",
        humidity: 72,
        windSpeed: 4.2,
        rainVolume: 0,
        highTemp: 26,
        lowTemp: 15,
        hourlyForecast: [],
        dailyForecast: [],
        timezoneOffset: 32400
    ))
    
}
