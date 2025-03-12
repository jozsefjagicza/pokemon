//
//  PokemonApp.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import SwiftUI
import SwiftData

@main
struct PokemonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        AppContainer.shared.setProductionContainer()
    }
}
