//
//  TomorrowView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/26/26.
//

import SwiftUI

struct TomorrowView: View {

    let day: DayWeather?
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: day?.iconName ?? "sun.max.fill")
                    .resizable()
                    .symbolRenderingMode(.multicolor)
                    .frame(width: 120, height: 120)
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text("Tomorrow")
                        .font(.title)
                    Text(day?.temperatureText ?? "--°")
                        .font(.system(size: 50))
                    Text(day?.condition ?? "Loading...")
                        .font(.title)
                }
            }
            
            HStack(spacing: 30){
                
                VStack{
                    Image(systemName: "cloud.rain")
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text(day?.rainVolumeText ?? "--mm")
                    Text("Rain")
                }
                
                Divider()
                    .frame(height: 50)
                
                VStack{
                    Image(systemName: "wind")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text(day?.windSpeedText ?? "--km/h")
                    Text("Wind Speed")
                }
                
                Divider()
                    .frame(height: 50)
                
                VStack{
                    Image(systemName: "humidity")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text(day?.humidityText ?? "--%")
                    Text("Humidity")
                }
            }
        }
        .padding()
        .glassEffect(.clear, in: .rect(cornerRadius: 20))
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.2), radius: 10, y: 6)
        .shadow(color: .white.opacity(0.3), radius: 3, y: -2)
    }
}


#Preview {
    TomorrowView(
        day: DayWeather(
            date: .now.addingTimeInterval(86400),
            condition: "clear",
            highTemp: 25,
            lowTemp: 16,
            humidity: 60,
            windSpeed: 8,
            rainVolume: 0.8)
    )
}
