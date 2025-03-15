//
//  PokeminInteractor.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 15..
//

import Foundation
import Combine
import Alamofire
import SwiftUI

protocol PokemonInteractorProtocol {
    func fetchPokemonDetails(for pokemonName: String) -> AnyPublisher<PokemonData, Error>
    func fetchSpeciesDetails(from urlString: String) -> AnyPublisher<PokemonSpeciesData, Error>
}

class PokemonInteractor: PokemonInteractorProtocol {
    func fetchPokemonDetails(for pokemonName: String) -> AnyPublisher<PokemonData, Error> {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonName)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return AF.request(url)
            .publishDecodable(type: PokemonData.self)
            .value()
            .mapError { $0 as Error } // AFError -> Error konverzió
            .eraseToAnyPublisher()
    }
    
    func fetchSpeciesDetails(from urlString: String) -> AnyPublisher<PokemonSpeciesData, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return AF.request(url)
            .publishDecodable(type: PokemonSpeciesData.self)
            .value()
            .mapError { $0 as Error } // AFError -> Error konverzió
            .eraseToAnyPublisher()
    }
}

