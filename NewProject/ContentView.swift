//
//  ContentView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 2/8/26.
//

import SwiftUI
import CoreLocation

struct ContentView: View {

    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherVM = WeaherViewModel()
    @StateObject private var locationStore = LocationDataStore()
    
    var body: some View {
        let weatherPages = weatherVM.weatherPages
        let selectedWeatherData = weatherPages.indices.contains(weatherVM.selectedWeatherPage)
        ? weatherPages[weatherVM.selectedWeatherPage]
        : weatherVM.weather
        
        NavigationStack{
            ZStack{
                LinearGradient(colors: [Color(red: 0.98, green: 0.7, blue: 0.5),
                                        Color(red: 0.95, green: 0.5, blue: 0.6),
                                        Color(red: 0.5, green: 0.4, blue: 0.8)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 20) {
                    WeatherSummaryCarousel(
                        weatherPages: weatherPages,
                        selectedPage: $weatherVM.selectedWeatherPage)

                    WeatherMetricPanel(weatherData: selectedWeatherData)
                    
                    HStack{
                        Text("Today")
                            .font(.title2)
                            .foregroundStyle(Color.yellow)
                        
                        Spacer()
                        
                        NavigationLink("Next 7 days >") {
                            WeeklyWeather(dailyForecast: selectedWeatherData?.dailyForecast ?? [])
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .glassEffect(.clear)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                        
                        
                    }
                    .padding(.horizontal)
                    
                    HourlyWeatherView(hourlyWeather: selectedWeatherData?.hourlyForecast ?? [])
                    Spacer()
                }
                
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack{
                            Menu{
                                ForEach(locationStore.locations) { location in
                                    Button(location.name){
                                        Task{
                                            await weatherVM.addCityWeather(location)
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .glassEffect(in: Circle())
                            }
                        }
                    }
                }
                .onAppear {
                    locationManager.requestLocation()
                }
                .onReceive(locationManager.$location) { location in
                    guard let location else { return }
                    guard weatherVM.weather == nil else { return}
                    Task{
                        await weatherVM.loadWeather(
                            lat: location.coordinate.latitude,
                            lon: location.coordinate.longitude
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
