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
    @Injected var interactor: PokemonInteractorProtocol

    @Published var pokemonData: PokemonDataDTO?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite: Bool = false
    private let reachabilityService: ReachabilityService

    private var cancellables = Set<AnyCancellable>()
    private let pokemonName: String

    init(pokemonName: String, reachabilityService: ReachabilityService) {
        self.pokemonName = pokemonName
        self.reachabilityService = reachabilityService
    }
    
    func fetchDetails() {
        isLoading = true

        if reachabilityService.isConnected {
            interactor.fetchPokemonDetails(for: pokemonName)
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
        else {
            self.pokemonData = interactor.fetchPokemonDataByName(pokemonName)
            let isFavorite = self.checkIfPokemonIsFavorite()
            self.pokemonData?.isFavorite = isFavorite
            self.isFavorite = isFavorite
            isLoading = false
        }
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
                if self.pokemonData != nil {
                    self.loadImageData(imageUrl: URL(string: self.pokemonData?.sprites.other.officialArtwork?.frontDefault ?? "")!)
                }
            })
            .store(in: &cancellables)
    }
    
    private func loadImageData(imageUrl: URL) {
        interactor.loadImage(from: imageUrl)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                Task {
                    guard let self = self, let pokemonData = self.pokemonData else { return }
                    self.pokemonData?.image = image?.pngData()
                    let isFavorite = self.checkIfPokemonIsFavorite()
                    self.pokemonData?.isFavorite = isFavorite
                    self.isFavorite = isFavorite
                    let data = PokemonData(from: pokemonData)
                    data.image = image?.pngData()
                    await self.interactor.savePokemonDataToDatabase(data)
                }
            }
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
    
    @MainActor
    func toggleFavoriteStatus() {
        interactor.updatePokemonFavoriteStatus(name: pokemonData?.name ?? "", isFavorite: isFavorite)
    }
    
    private func checkIfPokemonIsFavorite() -> Bool {
        return interactor.isPokemonFavorite(name: pokemonData?.name ?? "")
    }
}

