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
    private let refreshTokenKey = "refreshToken"
    
    private init() {}
    
    var accessToken: String? { get {return getAccessToken() }
        set { storeAccessToken(newValue) }
    }
    
    var refreshToken: String? { get {return getRefreshToken() }
        set { storeRefreshToken(newValue) }
    }
    
    
    func storeAccessToken(_ token: String?) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }
    
    func storeRefreshToken(_ token: String?) {
        UserDefaults.standard.set(token, forKey: refreshTokenKey)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshTokenKey)
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
    
    func clearAllSettings() {
        clearTokens()
    }
}

