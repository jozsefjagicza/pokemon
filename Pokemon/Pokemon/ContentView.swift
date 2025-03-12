//
//  ContentView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Injected var mainCoordinator: MainCoordinator

    public var body: some View {
        mainCoordinator
            .view()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
