//
//  PokemonData.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 14..
//

import Foundation
import SwiftData

@Model
class PokemonData {
    @Attribute var id: Int
    @Attribute var name: String
    @Attribute var height: Int
    @Attribute var baseExperience: Int
    @Attribute var order: Int
    @Attribute var abilities: [PokemonAbility]
    @Attribute var sprites: PokemonSprites
    @Attribute var species: PokemonSpecies
    @Attribute var speciesData: PokemonSpeciesData?
    @Attribute(.externalStorage) var image: Data?
    
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
        case image
    }
    
    init(id: Int,
         name: String,
         height: Int,
         baseExperience: Int,
         order: Int,
         abilities: [PokemonAbility],
         sprites: PokemonSprites,
         species: PokemonSpecies,
         speciesData: PokemonSpeciesData?,
         image: Data?) {
        self.id = id
        self.name = name
        self.height = height
        self.baseExperience = baseExperience
        self.order = order
        self.abilities = abilities
        self.sprites = sprites
        self.species = species
        self.speciesData = speciesData
        self.image = image
    }
    
    convenience init(from dto: PokemonDataDTO) {
        let sprites = PokemonSprites(from: dto.sprites)
        let species = PokemonSpecies(from: dto.species)
        
        let speciesData = dto.speciesData != nil ? PokemonSpeciesData(from: dto.speciesData!) : nil
        let image = dto.image
        
        self.init(id: dto.id,
                  name: dto.name,
                  height: dto.height,
                  baseExperience: dto.baseExperience,
                  order: dto.order,
                  abilities: dto.abilities.map { PokemonAbility(from: $0) },
                  sprites: sprites,
                  species: species,
                  speciesData: speciesData,
                  image: image)
    }
    
    func toDTO() -> PokemonDataDTO {
        return PokemonDataDTO(
            id: self.id,
            name: self.name,
            height: self.height,
            baseExperience: self.baseExperience,
            order: self.order,
            abilities: self.abilities.map { $0.toDTO() },
            sprites: self.sprites.toDTO(),
            species: self.species.toDTO(),
            speciesData: self.speciesData?.toDTO(),
            image: self.image
        )
    }
}

@Model
class PokemonAbility {
    @Attribute var ability: NamedAPIResource
    @Attribute var isHidden: Bool
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
    }
    
    func toDTO() -> PokemonAbilityDTO {
        return PokemonAbilityDTO(
            ability: NamedAPIResourceDTO(name: ability.name ?? "", url: ability.url),
            isHidden: isHidden
        )
    }
    
    init(ability: NamedAPIResource, isHidden: Bool) {
        self.ability = ability
        self.isHidden = isHidden
    }
    
    convenience init(from dto: PokemonAbilityDTO) {
        let abilityResource = NamedAPIResource(name: dto.ability.name ?? "", url: dto.ability.url ?? "")
        self.init(ability: abilityResource, isHidden: dto.isHidden)
    }
}

@Model
class PokemonSprites {
    @Attribute var frontDefault: String?
    @Attribute var frontShiny: String?
    @Attribute var backDefault: String?
    @Attribute var backShiny: String?
    @Attribute var other: PokemonSpritesOther?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case other
    }
    
    init(frontDefault: String? = nil,
         frontShiny: String? = nil,
         backDefault: String? = nil,
         backShiny: String? = nil,
         other: PokemonSpritesOther? = nil) {
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
        self.backDefault = backDefault
        self.backShiny = backShiny
        self.other = other
    }
    
    func toDTO() -> PokemonSpritesDTO {
        return PokemonSpritesDTO(
            frontDefault: self.frontDefault,
            frontShiny: self.frontShiny,
            backDefault: self.backDefault,
            backShiny: self.backShiny,
            other: self.other?.toDTO() ?? PokemonSpritesOtherDTO(officialArtwork: OfficialArtworkDTO(frontDefault: "", frontShiny: ""))
        )
    }
    
    convenience init(from dto: PokemonSpritesDTO) {
        self.init(frontDefault: dto.frontDefault,
                  frontShiny: dto.frontShiny,
                  backDefault: dto.backDefault,
                  backShiny: dto.backShiny,
                  other: PokemonSpritesOther(from: dto.other))
    }
}

@Model
class PokemonSpritesOther {
    @Attribute var officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
    
    func toDTO() -> PokemonSpritesOtherDTO {
        return PokemonSpritesOtherDTO(
            officialArtwork: self.officialArtwork.toDTO()
        )
    }
    
    init(officialArtwork: OfficialArtwork? = nil) {
        self.officialArtwork = officialArtwork ?? OfficialArtwork(frontDefault: "", frontShiny: "")
    }
    
    convenience init(from dto: PokemonSpritesOtherDTO?) {
        if let dto = dto {
            self.init(officialArtwork: dto.officialArtwork != nil ? OfficialArtwork(from: dto.officialArtwork!) : nil)
        } else {
            self.init(officialArtwork: nil)
        }
    }
}

@Model
class OfficialArtwork {
    @Attribute var frontDefault: String?
    @Attribute var frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
    
    func toDTO() -> OfficialArtworkDTO {
        return OfficialArtworkDTO(
            frontDefault: self.frontDefault ?? "",
            frontShiny: self.frontShiny ?? ""
        )
    }
    
    init(frontDefault: String? = nil, frontShiny: String? = nil) {
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
    }
    
    convenience init(from dto: OfficialArtworkDTO?) {
        self.init(frontDefault: dto?.frontDefault, frontShiny: dto?.frontShiny)
    }
}


@Model
class PokemonSpecies {
    @Attribute var url: String?
    
    func toDTO() -> PokemonSpeciesDTO {
        return PokemonSpeciesDTO(
            url: self.url ?? ""
        )
    }
    
    init(url: String) {
        self.url = url
    }
    
    convenience init(from dto: PokemonSpeciesDTO) {
        self.init(url: dto.url)
    }
}

@Model
class NamedAPIResource {
    @Attribute var name: String?
    @Attribute var url: String
    
    func toDTO() -> NamedAPIResourceDTO {
        return NamedAPIResourceDTO(name: self.name ?? "", url: self.url)
    }
    
    init(name: String,
         url: String) {
        self.name = name
        self.url = url
    }
    
    convenience init(from dto: NamedAPIResourceDTO) {
        self.init(name: dto.name ?? "",
                  url: dto.url ?? "")
    }
}

@Model
class PokemonSpeciesData {
    
    @Attribute var baseHappiness: Int
    @Attribute var captureRate: Int
    @Attribute var color: NamedAPIResource
    @Attribute var eggGroups: [NamedAPIResource]
    @Attribute var evolutionChain: NamedAPIResource
    @Attribute var evolvesFromSpecies: NamedAPIResource?
    @Attribute var flavorTextEntries: [FlavorTextEntry]
    @Attribute var genderRate: Int
    @Attribute var genera: [Genus]
    @Attribute var generation: NamedAPIResource
    @Attribute var growthRate: NamedAPIResource
    @Attribute var habitat: NamedAPIResource?
    @Attribute var hatchCounter: Int
    @Attribute var id: Int
    @Attribute var name: String
    @Attribute var names: [Name]
    
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
    }
    
    init(
        baseHappiness: Int,
        captureRate: Int,
        color: NamedAPIResource,
        eggGroups: [NamedAPIResource],
        evolutionChain: NamedAPIResource,
        evolvesFromSpecies: NamedAPIResource? = nil,
        flavorTextEntries: [FlavorTextEntry],
        genderRate: Int,
        genera: [Genus],
        generation: NamedAPIResource,
        growthRate: NamedAPIResource,
        habitat: NamedAPIResource? = nil,
        hatchCounter: Int,
        id: Int,
        name: String,
        names: [Name]
    ) {
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
    
    init(from dto: PokemonSpeciesDataDTO) {
        self.baseHappiness = dto.baseHappiness
        self.captureRate = dto.captureRate
        self.color = NamedAPIResource(name: dto.color.name ?? "", url: dto.color.url ?? "")
        self.eggGroups = dto.eggGroups.map { NamedAPIResource(name: $0.name ?? "", url: $0.url ?? "") }
        self.evolutionChain = NamedAPIResource(name: dto.evolutionChain.name ?? "", url: dto.evolutionChain.url ?? "")
        self.evolvesFromSpecies = dto.evolvesFromSpecies.map { NamedAPIResource(name: $0.name ?? "", url: $0.url ?? "") }
        self.flavorTextEntries = dto.flavorTextEntries.map { FlavorTextEntry(from: $0) }
        self.genderRate = dto.genderRate
        self.genera = dto.genera.map { Genus(from: $0) }
        self.generation = NamedAPIResource(name: dto.generation.name ?? "", url: dto.generation.url ?? "")
        self.growthRate = NamedAPIResource(name: dto.growthRate.name ?? "", url: dto.growthRate.url ?? "")
        self.habitat = dto.habitat.map { NamedAPIResource(name: $0.name ?? "", url: $0.url ?? "") }
        self.hatchCounter = dto.hatchCounter
        self.id = dto.id
        self.name = dto.name
        self.names = dto.names.map { Name(from: $0) }
    }
    
    func toDTO() -> PokemonSpeciesDataDTO {
        return PokemonSpeciesDataDTO(
            baseHappiness: self.baseHappiness,
            captureRate: self.captureRate,
            color: self.color.toDTO(),
            eggGroups: self.eggGroups.map { $0.toDTO() },
            evolutionChain: self.evolutionChain.toDTO(),
            evolvesFromSpecies: self.evolvesFromSpecies?.toDTO(),
            flavorTextEntries: self.flavorTextEntries.map { $0.toDTO() },
            genderRate: self.genderRate,
            genera: self.genera.map { $0.toDTO() },
            generation: self.generation.toDTO(),
            growthRate: self.growthRate.toDTO(),
            habitat: self.habitat?.toDTO(),
            hatchCounter: self.hatchCounter,
            id: self.id,
            name: self.name,
            names: self.names.map { $0.toDTO() }
        )
    }
}

@Model
class Genus {
    @Attribute var genus: String
    @Attribute var language: NamedAPIResource
    
    // **Designated Initializer**
    init(genus: String, language: NamedAPIResource) {
        self.genus = genus
        self.language = language
    }
    
    // **Initializer from DTO**
    init(from dto: GenusDTO) {
        self.genus = dto.genus
        self.language = NamedAPIResource(name: dto.language.name ?? "", url: dto.language.url ?? "")
    }
    
    // **Convert Back to DTO**
    func toDTO() -> GenusDTO {
        return GenusDTO(genus: self.genus, language: self.language.toDTO())
    }
}

@Model
class Name {
    @Attribute var name: String
    @Attribute var language: NamedAPIResource
    
    // **Designated Initializer**
    init(name: String, language: NamedAPIResource) {
        self.name = name
        self.language = language
    }
    
    // **Initializer from DTO**
    init(from dto: NameDTO) {
        self.name = dto.name
        self.language = NamedAPIResource(name: dto.language.name ?? "", url: dto.language.url ?? "")
    }
    
    // **Convert Back to DTO**
    func toDTO() -> NameDTO {
        return NameDTO(name: self.name, language: self.language.toDTO())
    }
}

@Model
class FlavorTextEntry {
    @Attribute var flavorText: String
    @Attribute var language: NamedAPIResource
    @Attribute var version: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case version
    }
    
    init(flavorText: String, language: NamedAPIResource, version: NamedAPIResource) {
        self.flavorText = flavorText
        self.language = language
        self.version = version
    }
    
    init(from dto: FlavorTextEntryDTO) {
        self.flavorText = dto.flavorText
        self.language = NamedAPIResource(name: dto.language.name ?? "", url: dto.language.url ?? "")
        self.version = NamedAPIResource(name: dto.version.name ?? "", url: dto.version.url ?? "")
    }
    
    func toDTO() -> FlavorTextEntryDTO {
        return FlavorTextEntryDTO(
            flavorText: self.flavorText,
            language: self.language.toDTO(),
            version: self.version.toDTO()
        )
    }
}


