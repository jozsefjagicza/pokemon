//
//  PokemonDetailsView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 14..
//

import SwiftUI
import Stinsen
import UIKit

struct PokemonDetailsView: View {
    @StateObject private var viewModel: PokemonDetailsViewModel
    @StateObject private var reachability = ReachabilityService()

    @State private var isShareSheetPresented = false
    @State private var imageToShare: UIImage?
    @State private var urlString: String?
    
    init(pokemonName: String, reachability: ReachabilityService = .init()) {
        _viewModel = StateObject(wrappedValue: PokemonDetailsViewModel(pokemonName: pokemonName, reachabilityService: reachability))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.backToHome()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
                
                Spacer()
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    if let pokemon = viewModel.pokemonData {
                        if let imageData = viewModel.pokemonData?.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    imageToShare = uiImage
                                    isShareSheetPresented = true
                                }
                        } else {
                            HStack {
                                Spacer()
                                Image("pokemonBall")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Spacer()
                            }
                        }
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                viewModel.isFavorite.toggle()
                                viewModel.toggleFavoriteStatus()
                            }) {
                                Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                                    .font(.title)
                                    .foregroundColor(.red)
                            }
                            .padding()
                        }
                        
                        Text(pokemon.name.capitalized)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("ID: \(pokemon.id)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Height: \(pokemon.height) dm")
                        Text("Base XP: \(pokemon.baseExperience)")
                        
                        VStack(alignment: .leading) {
                            Text("Alternative Names:")
                                .font(.headline)
                            ForEach(pokemon.speciesData?.names ?? [], id: \.name) { name in
                                Text("\(name.name.capitalized) (\(name.language.name?.capitalized ?? ""))")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Basic Information:")
                                .font(.headline)
                            Text("Species: \(pokemon.speciesData?.genera.first?.genus ?? "Unknown")")
                            Text("Generation: \(pokemon.speciesData?.generation.name?.capitalized ?? "")")
                            Text("Color: \(pokemon.speciesData?.color.name?.capitalized ?? "")")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Breeding Information:")
                                .font(.headline)
                            Text("Egg Groups: \(pokemon.speciesData?.eggGroups.map { $0.name?.capitalized ?? "" }.joined(separator: ", ") ?? "")")
                            Text("Gender Rate: \(pokemon.speciesData?.genderRate ?? 0)")
                            Text("Hatch Counter: \(pokemon.speciesData?.hatchCounter ?? 0)")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Growth Information:")
                                .font(.headline)
                            Text("Growth Rate: \(pokemon.speciesData?.growthRate.name?.capitalized ?? "")")
                            Text("Base Happiness: \(pokemon.speciesData?.baseHappiness ?? 0)")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Capture and Evolution:")
                                .font(.headline)
                            Text("Capture Rate: \(pokemon.speciesData?.captureRate ?? 0)")
                            Text("Evolves from: \(pokemon.speciesData?.evolvesFromSpecies?.name?.capitalized ?? "None")")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Abilities:")
                                .font(.headline)
                            ForEach(pokemon.abilities, id: \.ability.name) { ability in
                                Text("- \(ability.ability.name?.capitalized ?? "")")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Habitat:")
                                .font(.headline)
                            Text("\(pokemon.speciesData?.habitat?.name?.capitalized ?? "")")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Flavor Texts:")
                                .font(.headline)
                            ForEach(pokemon.speciesData?.flavorTextEntries ?? [], id: \.self) { text in
                                Text(text.flavorText)
                            }
                        }
                    } else if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Failed to load details")
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
                .onAppear {
                    viewModel.fetchDetails()
                }
                .sheet(isPresented: $isShareSheetPresented) {
                    if let imageURL = URL(string: viewModel.pokemonData?.sprites.other.officialArtwork?.frontDefault ?? "") {
                        ShareSheet(items: [imageURL], subject: viewModel.pokemonData?.name ?? "")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
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
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.dismissError() }
        )) {
            Alert(
                title: Text("Hiba"),
                message: Text(viewModel.errorMessage ?? "Ismeretlen hiba történt."),
                dismissButton: .default(Text("OK"), action: {
                    viewModel.dismissError()
                })
            )
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let subject: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.setValue(subject, forKey: "subject")
        
        return activityViewController
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

