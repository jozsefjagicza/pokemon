//
//  HomeInteractor.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation
import Combine
import SwiftData

protocol HomeInteractorProtocol {
    func fetchPokemons() -> AnyPublisher<[Pokemon], Error>
}

class HomeInteractor: HomeInteractorProtocol {

    var nextPageURL: String = "https://pokeapi.co/api/v2/pokemon/"
    
    func fetchPokemons() -> AnyPublisher<[Pokemon], Error> {
        guard let url = URL(string: nextPageURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        if !isConnectedToInternet() {
            return Fail(error: URLError(.notConnectedToInternet)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
                    .map { $0.data }
                    .decode(type: PokemonResponse.self, decoder: JSONDecoder())
                    .map { response in
                        let pokemons = response.results.map { Pokemon(from: $0) }
                        self.nextPageURL = response.next ?? ""
                        Task {
                            await self.savePokemonsToDatabase(pokemons)
                        }
                        return pokemons
                    }
                    .eraseToAnyPublisher()
    }
    
    @MainActor
    private func savePokemonsToDatabase(_ pokemons: [Pokemon]) {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: Pokemon.self)
        } catch {
            print("Nem sikerült betölteni a ModelContainer-t: \(error)")
            return
        }
        
        let context = container.mainContext
        
        for pokemon in pokemons {
            let pokemonEntity = Pokemon(id: pokemon.id, name: pokemon.name, url: pokemon.url)
            context.insert(pokemonEntity)
        }
        
        do {
            try context.save()
        } catch {
            print("Hiba a mentés során: \(error)")
        }
    }

    private func isConnectedToInternet() -> Bool {

        return true
    }
}


