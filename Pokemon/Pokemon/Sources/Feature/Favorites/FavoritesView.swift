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
    @StateObject private var reachability = ReachabilityService()

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.favoritePokemons, id: \.id) { pokemon in
                    Button {
                        viewModel.loadDetails(for: pokemon)
                    } label: {
                        HStack {
                            Text(pokemon.name.capitalized)
                            Spacer()
                            if let imageData = pokemon.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:50, height: 50)
                            } else {
                                Text("Nem sikerült a kép betöltése")
                            }
                        }
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
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.loadFavoritePokemons()
        }
    }
}

