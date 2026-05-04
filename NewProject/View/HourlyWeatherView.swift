//
//  HourlyWeatherView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/31/26.
//

import SwiftUI

struct HourlyWeatherView: View {
    
    let hourlyWeather: [TimeModel]
    
    private var nextTenHours: [TimeModel] {
        let now = Date()
        let upcomingHours = hourlyWeather
            .filter { $0.date >= now }
            .sorted { $0.date < $1.date }

        return Array(upcomingHours.prefix(10))
    }

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(nextTenHours) { hourWeather in
                    HourlyWeatherCard(hourlyWeather: hourWeather)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview{
    let now = Date()
    HourlyWeatherView(
        hourlyWeather: [
            TimeModel(date: now.addingTimeInterval(3600), temperature: 24, condition: "clouds"),
            TimeModel(date: now.addingTimeInterval(7200), temperature: 23, condition: "rain"),
            TimeModel(date: now.addingTimeInterval(10800), temperature: 23, condition: "clouds"),
            TimeModel(date: now.addingTimeInterval(14400), temperature: 22, condition: "clear"),
            TimeModel(date: now.addingTimeInterval(18000), temperature: 21, condition: "thunder"),
            TimeModel(date: now.addingTimeInterval(21600), temperature: 21, condition: "clouds"),
            TimeModel(date: now.addingTimeInterval(25200), temperature: 20, condition: "clear"),
            TimeModel(date: now.addingTimeInterval(28800), temperature: 19, condition: "rain"),
            TimeModel(date: now.addingTimeInterval(32400), temperature: 18, condition: "clouds")
        ]
    )
}
