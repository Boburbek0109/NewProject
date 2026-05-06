//
//  WeeklyWeather.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/25/26.
//

import SwiftUI

struct WeeklyWeather: View {
    let dailyForecast: [DayWeather]
    
    private var tomorrowForecast: DayWeather? {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
        
        return dailyForecast.first{
            Calendar.current.isDate($0.date, inSameDayAs: tomorrow)
        }
    }
    
    private var daysAfterTomorrow: [DayWeather] {
        let daysAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: .now) ?? .now
        
        return dailyForecast.filter{
            $0.date >= Calendar.current.startOfDay(for: daysAfterTomorrow)
        }
    }
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color(red: 0.98, green: 0.7, blue: 0.5),
                                    Color(red: 0.95, green: 0.5, blue: 0.6),
                                    Color(red: 0.5, green: 0.4, blue: 0.8)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 40){
                TomorrowView(day: tomorrowForecast)
                
                DaysWeatherView(dailyForecast: daysAfterTomorrow)
                
                Spacer()
            }
        }
    }
}


#Preview {
    WeeklyWeather(dailyForecast: [])
}
