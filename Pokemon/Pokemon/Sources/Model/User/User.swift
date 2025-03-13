//
//  User.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation

public struct User: Equatable {
    let id: Int
    let email: String
    let name: String
    let password: String
    
    init(
        id: Int,
        email: String,
        name: String,
        password: String
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.password = password
    }
}

