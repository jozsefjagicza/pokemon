//
//  HomeView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
            NavigationView {
                List {
                    ForEach(viewModel.pokemons, id: \.id) { pokemon in
                        Text(pokemon.name.capitalized)
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
                .navigationTitle("Pokémon List")
            }
        }
}

#Preview {
    HomeView()
}
