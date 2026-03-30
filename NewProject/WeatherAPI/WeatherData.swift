//
//  WeatherData.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/30/26.
//

import Foundation
import Combine
import CoreLocation

nonisolated struct WeatherData {
    let locationName: String
    let temperature: Double
    let condition: String
}

nonisolated struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [Weather]
}

nonisolated struct MainWeather: Codable {
    let temp: Double
}

nonisolated struct Weather: Codable {
    let description: String
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        
    }
    
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.location = location
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
