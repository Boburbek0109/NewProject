//
//  WeatherSummaryCarousel.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/5/26.
//

import SwiftUI

struct WeatherSummaryCarousel: View{
    
    let weatherPages: [WeatherData]
    @Binding var selectedPage: Int
    
    private var canSwipe: Bool{
        weatherPages.count > 1
    }
    
    var body: some View{
        VStack(spacing: 8) {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .glassEffect(.clear, in: .rect(cornerRadius: 20))
                
                if weatherPages.isEmpty {
                    WeatherSummary(weatherData: nil)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                } else {
                    TabView(selection: $selectedPage) {
                        ForEach(Array(weatherPages.enumerated()), id: \.element.id) { index, weatherData in
                            WeatherSummary(weatherData: weatherData)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 14)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .disabled(!canSwipe)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            
            if canSwipe {
                HStack(spacing: 6) {
                    ForEach(weatherPages.indices, id: \.self) { index in
                        Circle()
                            .fill(.white.opacity(selectedPage == index ? 0.8 : 0.35))
                            .frame(width: selectedPage == index ? 6 : 5,
                                   height: selectedPage == index ? 6 : 5)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    WeatherSummaryCarousel(weatherPages: [
        WeatherData (locationName: "Seoul",
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
                    )
        
    ], selectedPage: .constant(0)
    )
}
