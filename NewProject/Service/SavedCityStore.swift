//
//  SavedCityStore.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/12/26.
//

import SwiftData

@MainActor
struct SavedCityStore {
    
    var modelContext: ModelContext
    var savedCities: [SavedCity]
    
    var selectedLocation: LocationData? {
        savedCities.first?.locationData
    }
    
    func selectedCity(_ location: LocationData){
        clearSavedCity()
        
        let savedCity = SavedCity(
            name: location.name,
            latitude: location.latitude,
            longitude: location.longitude
        )
        modelContext.insert(savedCity)
        
    }
    
     func clearSavedCity() {
        for city in savedCities {
            modelContext.delete(city)
        }
    }
}
