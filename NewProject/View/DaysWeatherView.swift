//
//  DaysWeatherView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/26/26.
//

import SwiftUI

struct DaysWeatherView: View {
    
    @State private var weatherData: WeatherData?
    let dailyForecast: [DayWeather]
    
    var body: some View {
        VStack(spacing: 20){
            ForEach(dailyForecast){ day in
                WeatherRow(day: day.formatDay,
                           icon: weatherSymbolName(for: day.condition),
                           title: day.condition,
                           high: Int(day.highTemp.rounded()),
                           low: Int(day.lowTemp.rounded())
                )
            }
        }
        .padding()
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .bottom)
        
    }
}




#Preview {
    DaysWeatherView(
        dailyForecast: [
            DayWeather(date: .now.addingTimeInterval(86400), condition: "clear", highTemp: 25, lowTemp: 17),
            DayWeather(date: .now.addingTimeInterval(86400 * 2), condition: "rain", highTemp: 25, lowTemp: 17),
            DayWeather(date: .now.addingTimeInterval(86400 * 3), condition: "thunder", highTemp: 25, lowTemp: 17),
            DayWeather(date: .now.addingTimeInterval(86400 * 4), condition: "drizzle", highTemp: 25, lowTemp: 17),
            DayWeather(date: .now.addingTimeInterval(86400 * 5), condition: "snow", highTemp: 25, lowTemp: 17),
            DayWeather(date: .now.addingTimeInterval(86400 * 6), condition: "sun", highTemp: 25, lowTemp: 17)
        ]
    )
}
