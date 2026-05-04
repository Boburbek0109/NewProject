//
//  WeaherViewModel.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 4/29/26.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
final class WeaherViewModel: ObservableObject {
    
    @Published var weather: WeatherData?
    @Published var errorMessage: String?
    
    private var service = WeatherService()
    
    func loadWeather(lat: Double, lon: Double) async {
        do {
            weather = try await service.fetchWeather(lat: lat, lon: lon)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
