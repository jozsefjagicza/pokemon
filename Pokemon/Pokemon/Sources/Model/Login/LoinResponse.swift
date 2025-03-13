//
//  LoinResponse.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation

public struct LoginResponse: Equatable {
    let user: User
    let accessToken: String
    
    init(
        user: User,
        accessToken: String
    ) {
        self.user = user
        self.accessToken = accessToken
    }
}

