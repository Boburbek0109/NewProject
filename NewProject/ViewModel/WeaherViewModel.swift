//
//  WeaherViewModel.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 4/29/26.
//

import Foundation
import Combine

@MainActor
final class WeaherViewModel: ObservableObject {
    
    @Published var weather: WeatherData?
    @Published var selectedCityWeather: WeatherData?
    @Published var selectedWeatherPage = 0
    @Published var errorMessage: String?
    
    private var service = WeatherService()
    
    var weatherPages: [WeatherData] {
        [weather, selectedCityWeather].compactMap{ $0 }
    }
    
    func loadWeather(lat: Double, lon: Double) async {
        do {
            weather = try await service.fetchWeather(lat: lat, lon: lon)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func addCityWeather(_ location: LocationData) async {
        if selectedCityWeather?.locationName == location.name {
            selectedWeatherPage = weather == nil ? 0 : 1
            return
        }
        
        do {
            let weatherData = try await service.fetchWeather(
                lat: location.latitude,
                lon: location.longitude
            )
            selectedCityWeather = weatherData
            selectedWeatherPage = weather == nil ? 0 : 1
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
