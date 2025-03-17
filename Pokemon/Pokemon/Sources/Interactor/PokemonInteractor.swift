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
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
    func fetchFavoritePokemonData() -> [PokemonDataDTO]
    func updatePokemonFavoriteStatus(name: String, isFavorite: Bool)
    func isPokemonSaved(name: String) -> Bool
    func isPokemonFavorite(name: String) -> Bool
}

class PokemonInteractor: @preconcurrency PokemonInteractorProtocol {
    
    func fetchPokemonDetails(for pokemonName: String) -> AnyPublisher<PokemonDataDTO, Error> {
        let urlString = "\(Config.baseURL)\(pokemonName)"
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
                return pokemon
            } else {
                return nil
            }
        } catch {
            print("Hiba a Pokémon adatainak lekérdezése során: \(error)")
            return nil
        }
    }
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        Future { promise in
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        promise(.success(image))
                    } else {
                        promise(.success(nil))
                    }
                } catch {
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    @MainActor
    func fetchFavoritePokemonData() -> [PokemonDataDTO] {
        
        let container: ModelContainer
        do {
            container = try ModelContainer(for: PokemonData.self)
        } catch {
            print("Nem sikerült betölteni a ModelContainer-t: \(error)")
            return []
        }
        
        let context = container.mainContext
        
        let fetchDescriptor = FetchDescriptor<PokemonData>(
            predicate: #Predicate { $0.isFavorite == true }
        )
        
        do {
            let favoritePokemons = try context.fetch(fetchDescriptor)
            let pokemonDTOs = favoritePokemons.map { $0.toDTO() }
            return pokemonDTOs
        } catch {
            print("Hiba a Pokémon adatainak lekérdezése során: \(error)")
            return []
        }
    }
    
    @MainActor
    func updatePokemonFavoriteStatus(name: String, isFavorite: Bool) {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: PokemonData.self)
        } catch {
            print("Nem sikerült betölteni a ModelContainer-t: \(error)")
            return
        }
        
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<PokemonData>(predicate: #Predicate { $0.name == name })

        do {
            if let pokemonData = try context.fetch(fetchDescriptor).first {
                pokemonData.isFavorite = isFavorite
                try context.save()
            } else {
                print("Nem található Pokémon az adott azonosítóval.")
            }
        } catch {
            print("Hiba történt az adatmódosítás során: \(error)")
        }
    }
    
    @MainActor
    func isPokemonSaved(name: String) -> Bool {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: PokemonData.self)
        } catch {
            print("Nem sikerült betölteni a ModelContainer-t: \(error)")
            return false
        }
        
        let context = container.mainContext
        
        let fetchDescriptor = FetchDescriptor<PokemonData>(
            predicate: #Predicate { $0.name == name }
        )
        
        do {
            let results = try context.fetch(fetchDescriptor)
            return !results.isEmpty
        } catch {
            print("Hiba a Pokémon adatainak lekérdezése során: \(error)")
            return false
        }
    }

    @MainActor
    func isPokemonFavorite(name: String) -> Bool {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: PokemonData.self)
        } catch {
            print("Nem sikerült betölteni a ModelContainer-t: \(error)")
            return false
        }
        
        let context = container.mainContext
        
        let fetchDescriptor = FetchDescriptor<PokemonData>(
            predicate: #Predicate { $0.name == name && $0.isFavorite == true }
        )
        
        do {
            let results = try context.fetch(fetchDescriptor)
            return !results.isEmpty
        } catch {
            print("Hiba a Pokémon adatainak lekérdezése során: \(error)")
            return false
        }
    }
}

