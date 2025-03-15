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
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { pokemons in
                self.pokemons.append(contentsOf: pokemons)
                self.isLoading = false                
            })
            .store(in: &cancellables)
    }
    
    func loadDetails(for pokemon: Pokemon) {
        homeCoordinator.routeToDetails(pokemon: pokemon)
    }
}

