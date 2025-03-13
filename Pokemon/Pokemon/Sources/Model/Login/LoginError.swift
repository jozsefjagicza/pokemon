//
//  LoginError.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation

enum LoginError: Error {
    case invalidCredentials
    case invalidEmail
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password."
        case .invalidEmail:
            return "Invalid email format."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
