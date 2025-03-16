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
import SwiftData

protocol PokemonInteractorProtocol {
    func fetchPokemonDataByName(_ name: String) -> PokemonDataDTO?
    func fetchPokemonDetails(for pokemonName: String) -> AnyPublisher<PokemonDataDTO, Error>
    func fetchSpeciesDetails(from urlString: String) -> AnyPublisher<PokemonSpeciesDataDTO, Error>
    func savePokemonDataToDatabase(_ pokemonData: PokemonData) async
}

class PokemonInteractor: @preconcurrency PokemonInteractorProtocol {

    func fetchPokemonDetails(for pokemonName: String) -> AnyPublisher<PokemonDataDTO, Error> {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonName)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return AF.request(url)
            .publishDecodable(type: PokemonDataDTO.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func fetchSpeciesDetails(from urlString: String) -> AnyPublisher<PokemonSpeciesDataDTO, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return AF.request(url)
            .publishDecodable(type: PokemonSpeciesDataDTO.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    func savePokemonDataToDatabase(_ pokemonData: PokemonData) {
        print("FLAVOR: \(pokemonData.speciesData?.flavorTextEntries.first?.flavorText ?? "N/A")")

        let container: ModelContainer
            do {
                container = try ModelContainer(for: PokemonData.self)
            } catch {
                print("Nem sikerült betölteni a ModelContainer-t: \(error)")
                return
            }
            
            let context = container.mainContext

            do {
                context.insert(pokemonData)
                try context.save()
            } catch {
                print("Hiba a lekérdezés vagy mentés során: \(error)")
            }
    }
    
    @MainActor
    func fetchPokemonDataByName(_ name: String) -> PokemonDataDTO? {
        
        let container: ModelContainer
        do {
            container = try ModelContainer(for: PokemonData.self)
        } catch {
            print("Nem sikerült betölteni a ModelContainer-t: \(error)")
            return nil
        }
        
        let context = container.mainContext
        
        do {
            let fetchDescriptor = FetchDescriptor<PokemonData>(
                predicate: #Predicate { $0.name == name }
            )

            if let savedPokemon = try context.fetch(fetchDescriptor).first {
                let pokemon = savedPokemon.toDTO()
                print("Pokemon: \(name)")
                return pokemon
            } else {
                print("nincs ilyen pokémon")
                return nil
            }
        } catch {
            print("Hiba a Pokémon adatainak lekérdezése során: \(error)")
            return nil
        }
    }
}

