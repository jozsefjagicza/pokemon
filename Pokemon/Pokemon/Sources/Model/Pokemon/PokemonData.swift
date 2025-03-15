//
//  PokemonData.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 14..
//

import Foundation

struct PokemonData: Codable {
    let id: Int
    let name: String
    let height: Int
    let baseExperience: Int
    let order: Int
    let abilities: [PokemonAbility]
    let sprites: PokemonSprites
    let species: PokemonSpecies
    var speciesData: PokemonSpeciesData?
    let cries: PokemonCries
    let gameIndices: [PokemonGameIndices]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case height
        case baseExperience = "base_experience"
        case order
        case abilities
        case sprites
        case species
        case speciesData
        case cries
        case gameIndices = "game_indices"
    }
}

struct PokemonAbility: Codable {
    let ability: NamedAPIResource
    let isHidden: Bool
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
    }
}

struct PokemonSprites: Codable {
    let frontDefault: String?
    let frontShiny: String?
    let backDefault: String?
    let backShiny: String?
    let other: PokemonOtherSprites
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case other
    }
}

struct PokemonOtherSprites: Codable {
    let officialArtwork: OfficialArtwork
    let dreamWorld: DreamWorld?
    let home: HomeSprites?
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
        case dreamWorld = "dream_world"
        case home
    }
}

struct PokemonGameIndices: Codable {
    let uuid: String = UUID().uuidString
    let gameIndex: Int?
    let version: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String?
    let frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct DreamWorld: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct HomeSprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonSpecies: Codable {
    let url: String
}

struct PokemonCries: Codable {
    let latest: String?
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

struct PokemonSpeciesData: Codable {
    struct NamedAPIResource: Codable {
        let name: String?
        let url: String
    }
    
    struct FlavorTextEntry: Codable {
        let flavorText: String
        let language: NamedAPIResource
        let version: NamedAPIResource
        
        enum CodingKeys: String, CodingKey {
            case flavorText = "flavor_text"
            case language
            case version
        }
    }
    
    struct Genus: Codable {
        let genus: String
        let language: NamedAPIResource
    }
    
    struct Name: Codable {
        let name: String
        let language: NamedAPIResource
    }
    
    struct Variety: Codable {
        let isDefault: Bool
        let pokemon: NamedAPIResource
        
        enum CodingKeys: String, CodingKey {
            case isDefault = "is_default"
            case pokemon
        }
    }
    
    let baseHappiness: Int
    let captureRate: Int
    let color: NamedAPIResource
    let eggGroups: [NamedAPIResource]
    let evolutionChain: NamedAPIResource
    let evolvesFromSpecies: NamedAPIResource?
    let flavorTextEntries: [FlavorTextEntry]
    let formsSwitchable: Bool
    let genderRate: Int
    let genera: [Genus]
    let generation: NamedAPIResource
    let growthRate: NamedAPIResource
    let habitat: NamedAPIResource?
    let hasGenderDifferences: Bool
    let hatchCounter: Int
    let id: Int
    let isBaby: Bool
    let isLegendary: Bool
    let isMythical: Bool
    let name: String
    let names: [Name]
    let varieties: [Variety]

    enum CodingKeys: String, CodingKey {
        case baseHappiness = "base_happiness"
        case captureRate = "capture_rate"
        case color
        case eggGroups = "egg_groups"
        case evolutionChain = "evolution_chain"
        case evolvesFromSpecies = "evolves_from_species"
        case flavorTextEntries = "flavor_text_entries"
        case formsSwitchable = "forms_switchable"
        case genderRate = "gender_rate"
        case genera
        case generation
        case growthRate = "growth_rate"
        case habitat
        case hasGenderDifferences = "has_gender_differences"
        case hatchCounter = "hatch_counter"
        case id
        case isBaby = "is_baby"
        case isLegendary = "is_legendary"
        case isMythical = "is_mythical"
        case name
        case names
        case varieties
    }
}


