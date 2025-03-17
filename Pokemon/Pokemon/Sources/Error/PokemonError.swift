//
//  PokemonError.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 17..
//

import Foundation

enum PokemonError: Error {
    case badURL
    case modelContainerFailed(Error)
    case fetchFailed(Error)
    case networkError(URLError)
    case saveFailed(Error)
    case noPokemonFound

    var localizedDescription: String {
        switch self {
        case .badURL:
            return "Hibás URL: Az URL, amelyet megpróbáltunk elérni, érvénytelen."
        case .modelContainerFailed(let error):
            return "Nem sikerült betölteni a ModelContainer-t: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Hiba történt az adatok lekérése közben: \(error.localizedDescription)"
        case .networkError(let error):
            return "Hálózati hiba történt: \(error.localizedDescription)"
        case .saveFailed(let error):
            return "Hiba történt az adat mentése közben: \(error.localizedDescription)"
        case .noPokemonFound:
            return "Nem találtunk adatokat a keresett Pokémonhoz."
        }
    }
}


