//
//  SavedCity.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/11/26.
//

import Foundation
import SwiftData

@Model
final class SavedCity {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var locationData: LocationData {
        LocationData(name: name, latitude: latitude, longitude: longitude)
    }
}
