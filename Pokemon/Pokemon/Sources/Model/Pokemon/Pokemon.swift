//
//  Pokemon.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation

struct PokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct Pokemon: Identifiable, Decodable {
    let id: Int
    let name: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case name, url
    }
    
    init(id: Int, name: String, url: String) {
            self.id = id
            self.name = name
            self.url = url
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        self.id = Int(url.split(separator: "/").last ?? "0") ?? 0
    }
}


