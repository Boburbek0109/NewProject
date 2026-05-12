//
//  WeaherViewModel.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 4/29/26.
//

import Foundation
import Combine
import CoreLocation


final class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherData?
    @Published var selectedCityWeather: WeatherData?
    @Published var selectedWeatherPage = 0
    @Published var errorMessage: String?
    @Published var currentLocation: CLLocation?
    @Published var selectedCityLocation: LocationData?
    
    private var service: WeatherProviding
    
    init(service: WeatherProviding = WeatherService()) {
        self.service = service
    }
    
    var weatherPages: [WeatherData] {
        [weather, selectedCityWeather].compactMap{ $0 }
    }
    
    func loadWeather(location: CLLocation) async {
        let shouldKeepSelectedCityPage = weather == nil && selectedCityWeather != nil && selectedWeatherPage == 0
        currentLocation = location
        
        do {
            weather = try await service.fetchWeather(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude)
            if shouldKeepSelectedCityPage {
                selectedWeatherPage = 1
            }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func addCityWeather(_ location: LocationData) async {
        selectedCityLocation = location
        
        do {
            let weatherData = try await service.fetchWeather(
                lat: location.latitude,
                lon: location.longitude
            )
            selectedCityWeather = weatherData.renamed(to: location.name)
            selectedWeatherPage = weather == nil ? 0 : 1
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func refreshWeather() async {
        selectedCityWeather = nil
        selectedCityLocation = nil
        selectedWeatherPage = 0
        
        if let currentLocation {
            await loadWeather(location: currentLocation)
        }
    }
    
    var selectedWeatherData: WeatherData? {
        guard weatherPages.indices.contains(selectedWeatherPage) else {
            return weather
        }
        
        return weatherPages[selectedWeatherPage]
    }
    
    var selectedDailyForecast: [DayWeather] {
        selectedWeatherData?.dailyForecast ?? []
    }
    
    var selectedHourlyForecast: [TimeModel] {
        selectedWeatherData?.hourlyForecast ?? []
    }
    
    var canOpenWeeklyForecast: Bool {
        !selectedDailyForecast.isEmpty
    }
}
