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

    private var cancellables = Set<AnyCancellable>()
    private let pokemon: Pokemon

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }

    func fetchDetails() {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemon.name)"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }

        isLoading = true

        AF.request(url)
            .publishDecodable(type: PokemonData.self)
            .map(\.value)
            .compactMap { $0 }
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
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    private func fetchSpeciesDetails(from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid Species URL"
            return
        }

        AF.request(url)
            .publishDecodable(type: PokemonSpeciesData.self)
            .map(\.value)
            .compactMap { $0 }
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

