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

    @StateObject private var reachability = ReachabilityService()

    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.pokemons, id: \.id) { pokemon in
                        Button {
                            viewModel.loadDetails(for: pokemon.name)
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
                .navigationTitle("Pokémon List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.loadFavorites()
                        }) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    ToolbarItem(placement: .status) {
                        HStack {
                            Image(systemName: reachability.isConnected ? "wifi" : "wifi.slash")
                                .foregroundColor(reachability.isConnected ? .green : .red)
                            Text(reachability.isConnected ? "Online" : "Offline")
                                .font(.caption)
                                .foregroundColor(reachability.isConnected ? .green : .red)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}


