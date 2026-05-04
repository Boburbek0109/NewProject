//
//  LocationDataStore.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/2/26.
//

import Foundation
import Combine

struct LocationData: Decodable, Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
    }
}

final class LocationDataStore: ObservableObject {
    @Published private var locations: [LocationData] = []

    init() {
        loadData()
    }

    private func loadData() {
        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json") else {
            print("locations.json not found in app bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            locations = try JSONDecoder().decode([LocationData].self, from: data)
        } catch {
            print("Failed to load locations.json: \(error.localizedDescription)")
        }
    }
}
