//
//  FavoritesView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 17..
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.favoritePokemons, id: \.id) { pokemon in
                    Button {
                        viewModel.loadDetails(for: pokemon)
                    } label: {
                        Text(pokemon.name.capitalized)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Spacer()
        }
        .navigationTitle("Favorites")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.backToHome()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.loadFavoritePokemons()
        }
    }
}

