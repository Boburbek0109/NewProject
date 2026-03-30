//
//  DaysView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/26/26.
//

import SwiftUI

struct DaysView: View {
    var body: some View {
        
        VStack(spacing: 20){
            
            WeatherModel(day: "Sat", icon: "cloud.rain.fill", title: "Storm", high: 21, low: 7)
            WeatherModel(day: "Sun", icon: "cloud.fill", title: "Cloudy", high: 23, low: 8)
            WeatherModel(day: "Mon", icon: "cloud.bolt.rain.fill", title: "Windy", high: 24, low: 9)
            WeatherModel(day: "Tue", icon: "cloud.sun.rain.fill", title: "Cloudy Sunny", high: 22, low: 7)
            WeatherModel(day: "Wed", icon: "cloud.sun.fill", title: "Sunny", high: 27, low: 6)
            WeatherModel(day: "Thu", icon: "sun.max.fill", title: "Rainy", high: 20, low: 9)
        }
        .padding()
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .foregroundStyle(.white.gradient)
        
    }
}




#Preview {
    DaysView()
}
