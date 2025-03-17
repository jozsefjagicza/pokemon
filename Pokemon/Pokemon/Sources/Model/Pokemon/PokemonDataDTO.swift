//
//  PokemonDataDTO.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 15..
//

import Foundation
import SwiftData

struct PokemonDataDTO: Codable {
    var id: Int
    var url: String?
    var name: String
    var height: Int
    var baseExperience: Int
    var order: Int
    var abilities: [PokemonAbilityDTO]
    var sprites: PokemonSpritesDTO
    var species: PokemonSpeciesDTO
    var speciesData: PokemonSpeciesDataDTO?
    var image: Data?
    var isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case height
        case baseExperience = "base_experience"
        case order
        case abilities
        case sprites
        case species
        case speciesData
        case image
        case isFavorite
    }
    
    init(id: Int,
         url: String?,
         name: String,
         height: Int,
         baseExperience: Int,
         order: Int,
         abilities: [PokemonAbilityDTO],
         sprites: PokemonSpritesDTO,
         species: PokemonSpeciesDTO,
         speciesData: PokemonSpeciesDataDTO?,
         image: Data?,
         isFavorite: Bool?
        ) {
        self.id = id
        self.url = url
        self.name = name
        self.height = height
        self.baseExperience = baseExperience
        self.order = order
        self.abilities = abilities
        self.sprites = sprites
        self.species = species
        self.speciesData = speciesData
        self.image = image
        self.isFavorite = isFavorite
    }
}

struct PokemonAbilityDTO: Codable {
    var ability: NamedAPIResourceDTO
    var isHidden: Bool

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
    }
    init(ability: NamedAPIResourceDTO, isHidden: Bool) {
        self.ability = ability
        self.isHidden = isHidden
    }
}

struct PokemonSpritesDTO: Codable {
    var frontDefault: String?
    var frontShiny: String?
    var backDefault: String?
    var backShiny: String?
    var other: PokemonSpritesOtherDTO
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case other
    }

    init(frontDefault: String?,
         frontShiny: String?,
         backDefault: String?,
         backShiny: String?,
         other: PokemonSpritesOtherDTO) {
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
        self.backDefault = backDefault
        self.backShiny = backShiny
        self.other = other
    }
}

struct PokemonSpeciesDTO: Codable {
    var url: String

    init(url: String) {
        self.url = url
    }
}

struct PokemonSpritesOtherDTO: Codable {
    var officialArtwork: OfficialArtworkDTO?
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
    
    init(officialArtwork: OfficialArtworkDTO) {
        self.officialArtwork = officialArtwork
    }
}

struct OfficialArtworkDTO: Codable {
    var frontDefault: String?
    var frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
    
    init(frontDefault: String,
         frontShiny: String) {
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
    }
}

struct NamedAPIResourceDTO: Codable, Hashable {
    var name: String?
    var url: String?

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

struct PokemonSpeciesDataDTO: Codable {
    var baseHappiness: Int
    var captureRate: Int
    var color: NamedAPIResourceDTO
    var eggGroups: [NamedAPIResourceDTO]
    var evolutionChain: NamedAPIResourceDTO
    var evolvesFromSpecies: NamedAPIResourceDTO?
    var flavorTextEntries: [FlavorTextEntryDTO]
    var genderRate: Int
    var genera: [GenusDTO]
    var generation: NamedAPIResourceDTO
    var growthRate: NamedAPIResourceDTO
    var habitat: NamedAPIResourceDTO?
    var hatchCounter: Int
    var id: Int
    var name: String
    var names: [NameDTO]

    enum CodingKeys: String, CodingKey {
        case baseHappiness = "base_happiness"
        case captureRate = "capture_rate"
        case color
        case eggGroups = "egg_groups"
        case evolutionChain = "evolution_chain"
        case evolvesFromSpecies = "evolves_from_species"
        case flavorTextEntries = "flavor_text_entries"
        case genderRate = "gender_rate"
        case genera
        case generation
        case growthRate = "growth_rate"
        case habitat
        case hatchCounter = "hatch_counter"
        case id
        case name
        case names
    }
    
    init(baseHappiness: Int,
         captureRate: Int,
         color: NamedAPIResourceDTO,
         eggGroups: [NamedAPIResourceDTO],
         evolutionChain: NamedAPIResourceDTO,
         evolvesFromSpecies: NamedAPIResourceDTO?,
         flavorTextEntries: [FlavorTextEntryDTO],
         genderRate: Int,
         genera: [GenusDTO],
         generation: NamedAPIResourceDTO,
         growthRate: NamedAPIResourceDTO,
         habitat: NamedAPIResourceDTO?,
         hatchCounter: Int,
         id: Int,
         name: String,
         names: [NameDTO]) {
        self.baseHappiness = baseHappiness
        self.captureRate = captureRate
        self.color = color
        self.eggGroups = eggGroups
        self.evolutionChain = evolutionChain
        self.evolvesFromSpecies = evolvesFromSpecies
        self.flavorTextEntries = flavorTextEntries
        self.genderRate = genderRate
        self.genera = genera
        self.generation = generation
        self.growthRate = growthRate
        self.habitat = habitat
        self.hatchCounter = hatchCounter
        self.id = id
        self.name = name
        self.names = names
    }
}

struct FlavorTextEntryDTO: Codable, Hashable {
    var flavorText: String
    var language: NamedAPIResourceDTO
    var version: NamedAPIResourceDTO

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case version
    }
    
    init(flavorText: String, language: NamedAPIResourceDTO, version: NamedAPIResourceDTO) {
        self.flavorText = flavorText
        self.language = language
        self.version = version
    }
}

struct GenusDTO: Codable {
    var genus: String
    var language: NamedAPIResourceDTO

    init(genus: String, language: NamedAPIResourceDTO) {
        self.genus = genus
        self.language = language
    }
}

struct NameDTO: Codable {
    var name: String
    var language: NamedAPIResourceDTO

    init(name: String, language: NamedAPIResourceDTO) {
        self.name = name
        self.language = language
    }
}



