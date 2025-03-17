//
//  FavoritesViewModel.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 17..
//

import Foundation
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoritePokemons: [PokemonDataDTO] = []
    
    @Published var showingErrorAlert: Bool = false
    @Published var alertMessage: String = ""

    private var cancellables: Set<AnyCancellable> = []
    
    @Injected var interactor: PokemonInteractorProtocol
    @Injected var homeCoordinator: HomeCoordinatorProtocol
    
    func loadFavoritePokemons() {
        do {
            self.favoritePokemons = try interactor.fetchFavoritePokemonData()
        } catch let error as PokemonError {
            showError(error.localizedDescription)
        } catch {
            showError("Ismeretlen hiba történt: \(error.localizedDescription)")
        }
    }
    
    func loadDetails(for pokemon: PokemonDataDTO) {
        homeCoordinator.routeToDetails(pokemonName: pokemon.name)
    }
    
    func backToHome() {
        homeCoordinator.backToHome()
    }
    
    private func showError(_ message: String) {
        alertMessage = message
        showingErrorAlert = true
    }
}


