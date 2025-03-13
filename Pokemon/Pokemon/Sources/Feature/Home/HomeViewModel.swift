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
    @Published var nextPageURL: String = "https://pokeapi.co/api/v2/pokemon/"
    
    private var cancellables = Set<AnyCancellable>()
    @Injected var interactor: HomeInteractorProtocol

    init() {
        fetchPokemons()
    }
    
    func fetchPokemons() {
        let urlString = nextPageURL
        isLoading = true
        
        interactor.fetchPokemons(from: urlString)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.pokemons.append(contentsOf: response.results)
                self.nextPageURL = response.next ?? ""
            })
            .store(in: &cancellables)
    }
}


