//
//  HomeViewModel.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    @Injected var interactor: HomeInteractorProtocol
    @Injected var homeCoordinator: HomeCoordinatorProtocol

    init() {
        self.fetchPokemons()
    }
    
    func fetchPokemons() {
        isLoading = true
        
        interactor.fetchPokemons()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] pokemons in
                guard let self = self else { return }
                self.pokemons.append(contentsOf: pokemons)
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func loadDetails(for pokemonName: String) {
        homeCoordinator.routeToDetails(pokemonName: pokemonName)
    }
    
    func loadFavorites() {
        homeCoordinator.routeToFavorites()
    }
    
    func dismissError() {
        errorMessage = nil
    }
}

