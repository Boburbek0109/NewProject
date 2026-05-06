//
//  OpenWeatherResponse.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 4/29/26.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let name: String
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: Wind
    let rain: Rain?
    let timezone: Int
}

struct MainWeather: Decodable {
    let temp: Double
    let humidity: Int
    let tempMax: Double
    let tempMin: Double
    
    enum CodingKeys: String, CodingKey{
        case temp
        case humidity
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
    
}

struct WeatherCondition: Decodable {
    let description: String
}

struct Wind: Decodable{
    let speed: Double
}

struct Rain: Decodable{
    let oneHour: Double?
    let threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}


struct ForecastResponse: Decodable {
    let list: [ForecastItem]
    let city: ForecastCity
}

struct ForecastCity: Decodable{
    let name: String
}

struct ForecastItem: Decodable{
    let dt: TimeInterval
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: Wind?
    let rain: Rain?
}
