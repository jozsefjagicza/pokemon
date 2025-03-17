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
        let pokemon = Pokemon(id: pokemon.id, name: pokemon.name, url: pokemon.url ?? "")
        homeCoordinator.routeToDetails(pokemon: pokemon)
    }
    
    func backToHome() {
        homeCoordinator.backToHome()
    }
}
