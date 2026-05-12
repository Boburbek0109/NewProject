//
//  DaysWeatherView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/26/26.
//

import SwiftUI

struct DaysWeatherView: View {
    
    let dailyForecast: [DayWeather]
    
    var body: some View {
        VStack(spacing: 20){
            ForEach(dailyForecast){ day in
                WeatherRow(day: day.formatDay,
                           icon: weatherSymbolName(for: day.condiction),
                           title: day.condiction,
                           high: Int(day.highTemp.rounded()),
                           low: Int(day.lowTemp.rounded())
                )
            }
        }
        .padding()
        .glassEffect(.clear, in: .rect(cornerRadius: 20))
        .padding(.horizontal)        
    }
}




#Preview {
    DaysWeatherView(
        dailyForecast: [
            DayWeather(date: .now.addingTimeInterval(86400), condiction: "clear", highTemp: 25, lowTemp: 17, humidity: 70, windSpeed: 9, rainVolume: 0),
            DayWeather(date: .now.addingTimeInterval(86400 * 2), condiction: "rain", highTemp: 25, lowTemp: 17, humidity: 70, windSpeed: 9, rainVolume: 0),
            DayWeather(date: .now.addingTimeInterval(86400 * 3), condiction: "thunder", highTemp: 25, lowTemp: 17, humidity: 70, windSpeed: 9, rainVolume: 0),
            DayWeather(date: .now.addingTimeInterval(86400 * 4), condiction: "drizzle", highTemp: 25, lowTemp: 17, humidity: 70, windSpeed: 9, rainVolume: 0),
            DayWeather(date: .now.addingTimeInterval(86400 * 5), condiction: "snow", highTemp: 25, lowTemp: 17, humidity: 70, windSpeed: 9, rainVolume: 0),
            DayWeather(date: .now.addingTimeInterval(86400 * 6), condiction: "sun", highTemp: 25, lowTemp: 17, humidity: 70, windSpeed: 9, rainVolume: 0)
        ]
    )
}
