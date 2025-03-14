//
//  HomeView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import SwiftUI
import Stinsen

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    private var coordinator: HomeCoordinator

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        NavigationStack {
        List {
            ForEach(viewModel.pokemons, id: \.id) { pokemon in
                Button {
                    coordinator.routeToDetails(pokemon: pokemon)
                } label: {
                    Text(pokemon.name.capitalized)
                }
                .buttonStyle(PlainButtonStyle())
                .onAppear {
                    if pokemon.id == viewModel.pokemons.last?.id {
                        viewModel.fetchPokemons()
                    }
                }
            }
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
    }
            .navigationTitle("Pokémon List")
    }
}

