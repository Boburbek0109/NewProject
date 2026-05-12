//
//  NewProjectApp.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 2/8/26.
//

import SwiftUI
import SwiftData

@main
struct NewProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedCity.self)
    }
}
