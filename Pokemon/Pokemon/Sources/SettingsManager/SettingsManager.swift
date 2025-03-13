//
//  SettingsManager.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import Foundation

class SettingsManager {
    
    static let shared = SettingsManager()

    private let accessTokenKey = "accessToken"
    
    private init() {}
    
    var accessToken: String? { get {return getAccessToken() }
        set { storeAccessToken(newValue) }
    }
    
    func storeAccessToken(_ token: String?) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
    }
    
    func clearAllSettings() {
        clearTokens()
    }
}

