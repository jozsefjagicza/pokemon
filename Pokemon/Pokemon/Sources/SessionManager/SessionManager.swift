//
//  SessionManager.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import Foundation
import Combine
import UIKit

protocol SessionManagerType {
    var stateSubject: PassthroughSubject<SessionState, Never> { get set }
    
    func logout()
    func updateState()
    func storeLogInData(
        accessToken: String
    )
    func getDeviceId() -> String?
    func getDeviceModel() -> String
}

class SessionManager: SessionManagerType {
    
    private var cancellables = Set<AnyCancellable>()
    var stateSubject = PassthroughSubject<SessionState, Never>()
    @Injected var settingsManager: SettingsManager!
    
    private var password: String?

    func updateState() {
        if isLoggedIn() {
            stateSubject.send(.loggedIn)
        } else {
            stateSubject.send(.loggedOut)
        }
    }
    
    func isLoggedIn() -> Bool {
        return settingsManager.accessToken != nil
    }
    
    func logout() {
        settingsManager.clearTokens()
        password = nil
        updateState()
    }
    
    func getAccessToken() -> String? {
        settingsManager.accessToken
    }
    
    func storeLogInData(
        accessToken: String
    ) {
        settingsManager.accessToken = accessToken
    }
    
    func getDeviceId() -> String? {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        }
        return nil
    }
    
    func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let identifier = withUnsafeBytes(of: &systemInfo.machine) { buffer in
            buffer.compactMap { $0 != 0 ? String(UnicodeScalar(UInt8($0))) : nil }.joined()
        }
        return identifier
    }
}

