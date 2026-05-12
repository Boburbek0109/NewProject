//
//  ContentView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 2/8/26.
//

import SwiftUI
import CoreLocation
import SwiftData

@MainActor
struct ContentView: View {

    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherVM = WeatherViewModel()
    @StateObject private var locationStore = LocationDataStore()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var savedCities: [SavedCity]
    
    @State private var didRestoreSavedCity = false
    
    private var savedCityStore: SavedCityStore{
        SavedCityStore(modelContext: modelContext, savedCities: savedCities)}
    
    
    var body: some View {
        let selectedWeatherData = weatherVM.selectedWeatherData
        
        NavigationStack{
            ZStack{
                LinearGradient(colors: [Color(red: 0.98, green: 0.7, blue: 0.5),
                                        Color(red: 0.95, green: 0.5, blue: 0.6),
                                        Color(red: 0.5, green: 0.4, blue: 0.8)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                ScrollView{
                    VStack(alignment: .center, spacing: 20) {
                        WeatherSummaryCarousel(
                            weatherPages: weatherVM.weatherPages,
                            selectedPage: $weatherVM.selectedWeatherPage)

                        WeatherMetricPanel(weatherData: selectedWeatherData)
                        
                        HStack{
                            Text("Today")
                                .font(.title2)
                                .foregroundStyle(Color.yellow)
                            
                            Spacer()
                            
                            NavigationLink("Next 7 days >") {
                                WeeklyWeather(dailyForecast: weatherVM.selectedDailyForecast)
                            }
                            .disabled(!weatherVM.canOpenWeeklyForecast)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .glassEffect(.clear)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                            
                            
                        }
                        .padding(.horizontal)
                        
                        HourlyWeatherView(hourlyWeather: weatherVM.selectedHourlyForecast)
                        Spacer()
                    }
                }
                .refreshable {
                    savedCityStore.clearSavedCity()
                    await weatherVM.refreshWeather()
                }
                
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        cityMenu
                    }
                }
                .onAppear {
                    locationManager.requestLocation()
                }
                .onReceive(locationManager.$location) { location in
                    guard let location else { return }
                    guard weatherVM.weather == nil else { return}
                    Task{
                        await weatherVM.loadWeather(location: location)
                    }
                }
                .task {
                    guard !didRestoreSavedCity else { return }
                    didRestoreSavedCity = true
                    
                    guard  let location = savedCityStore.selectedLocation else { return }
                    
                    await weatherVM.addCityWeather(location)
                    weatherVM.selectedWeatherPage = weatherVM.weather == nil ? 0 : 1
                }
            }
        }
    }
    
    private var cityMenu: some View{
        Menu{
            ForEach(locationStore.locations) { location in
                Button(location.name){
                    savedCityStore.selectedCity(location)
                    
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

#Preview {
    ContentView()
}


