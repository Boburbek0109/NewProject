//
//  TimeModel.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 4/29/26.
//

import Foundation

struct TimeModel: Identifiable {
    let date: Date
    let temperature: Double
    let condiction: String?
    let timezoneOffset: Int
    
    var id: Date { date }
    
    init(date: Date, temperature: Double, condiction: String?, timezoneOffset: Int = TimeZone.current.secondsFromGMT()){
        self.date = date
        self.condiction = condiction
        self.temperature = temperature
        self.timezoneOffset = timezoneOffset
    }
  
    var formatHour: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        formatter.dateFormat = "h a"
        return formatter.string(from: date)
    }
    
    func weatherSymbolNameDN(for condition: String?, at date: Date) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: timezoneOffset) ?? .current
        
        let hour = calendar.component(.hour, from: date)
        let isDaytime = hour >= 6 && hour < 18

        guard let condition else {
            return isDaytime ? "cloud.sun.fill" : "cloud.moon.fill"
        }

        let normalizedCondition = condition.lowercased()

        if normalizedCondition.contains("rain") || normalizedCondition.contains("drizzle") {
            return "cloud.rain.fill"
        }

        if normalizedCondition.contains("clear") || normalizedCondition.contains("sun") {
            return isDaytime ? "sun.max.fill" : "moon.stars.fill"
        }

        if normalizedCondition.contains("thunder") {
            return "cloud.bolt.rain.fill"
        }

        if normalizedCondition.contains("snow") {
            return "cloud.snow.fill"
        }

        if normalizedCondition.contains("cloud") {
            return isDaytime ? "cloud.fill" : "cloud.moon.fill"
        }

        return isDaytime ? "cloud.sun.fill" : "cloud.moon.fill"
    }
}
