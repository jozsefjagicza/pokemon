//
//  Pokemon.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation
import SwiftData

struct PokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonDTO]  // Az átalakított adatok, amiket majd SwiftData-ba mentünk
}

// Az átalakított modell, amely nem implementálja a Decodable-t, hanem SwiftData-hoz illeszkedik
@Model
class Pokemon {
    @Attribute var id: Int
    @Attribute var name: String
    @Attribute var url: String
    
    // Alapértelmezett init
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
    
    // Az init a DTO-ból történő átalakításhoz
    convenience init(from dto: PokemonDTO) {
        self.init(id: dto.id, name: dto.name, url: dto.url)
    }
}

// A PokemonDTO típus, ami megfelel a JSON struktúrának, és megfelel a Decodable protokollnak
struct PokemonDTO: Decodable {
    let name: String
    let url: String
    var id: Int {
        let urlParts = url.split(separator: "/")
        return Int(urlParts.last ?? "0") ?? 0
    }
}

