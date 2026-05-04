//
//  ContentView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 2/8/26.
//

import SwiftUI
import CoreLocation
import Combine


struct ContentView: View {

    private var weatherService = WeatherService()
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [.cyan, .green, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 10) {
                    Text(weatherData?.condition ?? "Loading weather...")
                        .font(.title)
                    if let weatherData = weatherData {
                        Text(weatherData.locationName)
                            .font(.title2)
                    }
                    
                    Image(systemName: weatherData?.iconName ?? "cloud.sun.fill")
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .frame(width: 96, height: 96)
                    
                    Text("\(Date().formatted(.dateTime.day().month().weekday())) | \(Date().formatted(.dateTime.hour().minute()))")
                        .font(.title2)
                    
                    if let weatherData = weatherData {
                        Text(weatherData.temperatureText)
                            .font(.system(size: 60))
                            .frame(width: 150)
                    } else {
                        ProgressView()
                    }
                    
                    
                    HStack(spacing: 8) {
                        Text(weatherData?.highTempText ?? "H: --")
                        Text(weatherData?.lowTempText ?? "L: --")
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .glassEffect(.clear, in: .rect(cornerRadius: 20))
                            .frame(height: 150)
                        
                    HStack(spacing: 30){
                            WeatherMetricView(iconName: weatherData?.iconName ?? "sun.fill", value: weatherData?.rainVolumeText ?? "0.0mm", title: "Rain")
                        
                        Divider()
                            .frame(height: 50)
                            
                            WeatherMetricView(iconName: "wind", value: weatherData?.windSpeedText ?? "0.0 km/h", title: "Wind\nSpeed")
                        
                        Divider()
                            .frame(height: 50)
                                                        
                            WeatherMetricView(iconName: "humidity", value: weatherData?.humidityText ?? "0%", title: "Humidity")
                            
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("Today")
                            .font(.title)
                            .foregroundStyle(Color.yellow)
                        
                        Spacer()
                        
                        NavigationLink("Next 7 days >") {
                            WeeklyWeather(dailyForecast: weatherData?.dailyForecast ?? [])
                        }
                        .padding()
                        .glassEffect(.clear)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                        
                        
                    }
                    .padding(.horizontal)
                    
                    HourlyWeatherView(hourlyWeather: weatherData?.hourlyForecast ?? [])
                    
                    Spacer()
                    
                }
                .onAppear {
                    locationManager.requestLocation()
                }
                .onReceive(locationManager.$location) { location in
                    guard let location else { return }
                    Task{
                        do{
                            weatherData = try await weatherService.fetchWeather(
                                lat: location.coordinate.latitude,
                                lon: location.coordinate.longitude
                            )
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
