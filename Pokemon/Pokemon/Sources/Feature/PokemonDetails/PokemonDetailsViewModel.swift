//
//  PokemonDetailsViewModel.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 14..
//

import Foundation
import Combine
import Alamofire
import UIKit
import SwiftUI

@MainActor
class PokemonDetailsViewModel: ObservableObject {
    @Injected var homeCoordinator: HomeCoordinatorProtocol
    @Published var pokemonData: PokemonData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Injected var interactor: PokemonInteractorProtocol

    private var cancellables = Set<AnyCancellable>()
    private let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    func fetchDetails() {
        isLoading = true
        interactor.fetchPokemonDetails(for: pokemon.name)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { data in
                self.pokemonData = data
                self.fetchSpeciesDetails(from: data.species.url)
            })
            .store(in: &cancellables)
    }
    
    private func fetchSpeciesDetails(from urlString: String) {
        interactor.fetchSpeciesDetails(from: urlString)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { speciesData in
                self.pokemonData?.speciesData = speciesData
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func backToHome() {
        homeCoordinator.backToHome()
    }
    
    func convertToUIImage(_ image: Image) -> UIImage? {
        let controller = UIHostingController(rootView: image)
        let view = controller.view
        let targetSize = view?.intrinsicContentSize ?? CGSize(width: 200, height: 200)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        view?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let uiImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return uiImage
    }
}

