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
    @Published var errorMessage: String? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Injected var interactor: PokemonInteractorProtocol
    @Injected var homeCoordinator: HomeCoordinatorProtocol
    
    func loadFavoritePokemons() {
        
        self.favoritePokemons = interactor.fetchFavoritePokemonData()
        print(favoritePokemons.count)
        
    }
    
    func loadDetails(for pokemon: PokemonDataDTO) {
        homeCoordinator.routeToDetails(pokemonName: pokemon.name)
    }
    
    func backToHome() {
        homeCoordinator.backToHome()
    }
}
