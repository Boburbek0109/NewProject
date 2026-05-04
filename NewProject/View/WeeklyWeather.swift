//
//  WeeklyWeather.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/25/26.
//

import SwiftUI

struct WeeklyWeather: View {
    let dailyForecast: [DayWeather]
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.cyan, .green, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack{
                TomorrowView()
                
                DaysWeatherView(dailyForecast: dailyForecast)
                
            }
        }
    }
}


#Preview {
    WeeklyWeather(dailyForecast: [])
}
