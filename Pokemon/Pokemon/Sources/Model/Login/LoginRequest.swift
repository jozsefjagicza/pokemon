//
//  LoginRequest.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation

public struct LoginRequest {
    let email: String
    let password: String
    let deviceId: String
    let appVersion: String
    let phoneOsVersion: String?
    let phoneType: String?
    
    init(
        email: String,
        password: String,
        deviceId: String,
        appVersion: String,
        phoneOsVersion: String,
        phoneType: String
    ) {
        self.email = email
        self.password = password
        self.deviceId = deviceId
        self.appVersion = appVersion
        self.phoneOsVersion = phoneOsVersion
        self.phoneType = phoneType
    }
}

