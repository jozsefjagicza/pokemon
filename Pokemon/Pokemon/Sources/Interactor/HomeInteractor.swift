//
//  HomeInteractor.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation
import Combine

protocol HomeInteractorProtocol {
    func loadNextPageURL() -> String
    func fetchPokemons(from urlString: String) -> AnyPublisher<PokemonResponse, Error>
}

class HomeInteractor: HomeInteractorProtocol {
   
    func loadNextPageURL() -> String {
        return UserDefaults.standard.string(forKey: "nextPageURL") ?? "https://pokeapi.co/api/v2/pokemon/"
    }
    
    func fetchPokemons(from urlString: String) -> AnyPublisher<PokemonResponse, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

