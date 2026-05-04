//
//  TomorrowView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/26/26.
//

import SwiftUI

struct TomorrowView: View {
    
    @State private var weatherService = WeatherService()
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .padding(.horizontal)
                .frame(height: 350)
            
            VStack{
                HStack{
                    Image(systemName: "cloud.snow.fill")
                        .resizable()
                        .frame(width: 120, height: 150)
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        Text("Tommorow")
                            .font(.title)
                        Text("25°")
                            .font(.system(size: 50))
                        Text("Mostly Cloud")
                            .font(.title)
                    }
                }
                .padding(.horizontal, 30)
                
                
                HStack(spacing: 30){
                    VStack{
                        Image("rain.umbrella")
                            .resizable()
                            .frame(width: 70, height: 70)
                        
                        Text("80%")
                        Text("Rain")
                    }
                    //Spacer()
                    
                    VStack{
                        Image("wind.speed")
                            .resizable()
                            .frame(width: 70, height: 70)
                        Text("8km/h")
                        Text("Wind Speed")
                    }
                    //Spacer()
                    
                    VStack{
                        Image("humidity")
                            .resizable()
                            .frame(width: 70, height: 70)
                        Text("60%")
                        Text("Humidity")
                    }
                }
                .padding(.horizontal)
            }
            .foregroundStyle(.white.gradient)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}


#Preview {
    TomorrowView()
}
