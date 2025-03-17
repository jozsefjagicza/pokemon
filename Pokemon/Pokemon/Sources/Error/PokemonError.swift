//
//  PokemonError.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 17..
//

import Foundation

enum PokemonError: Error {
    case modelContainerFailed(Error)
    case fetchFailed(Error)
    
    var localizedDescription: String {
        switch self {
        case .modelContainerFailed(let error):
            return "Nem sikerült betölteni a ModelContainer-t: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Hiba történt az adatok lekérése közben: \(error.localizedDescription)"
        }
    }
}

