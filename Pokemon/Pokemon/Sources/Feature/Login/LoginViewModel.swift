//
//  LoginViewModel.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    
    @Injected private var sessionManager: SessionManagerType
    @Injected var interactor: LoginInteractorProtocol

    @Published var email: String = "" {
        didSet { onEmailChange() }
    }
    @Published var password: String = "" {
        didSet { onPasswordChange() }
    }
    @Published var isLoading: Bool = false
    @Published var errorAlert: Bool = false
    @Published var errorEmailMessage: String? = nil
    @Published var errorPasswordMessage: String? = nil
    @Published var errorAlertMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()

    func login() {
        guard !email.isEmpty else {
            errorEmailMessage = "Az e-mail mezőt ki kell tölteni!"
            return
        }
        
        guard !password.isEmpty else {
            errorPasswordMessage = "A jelszó mezőt ki kell tölteni!"
            return
        }
        
        guard validateEmail(email: email) else {
            errorEmailMessage = "Hibás email formátum!"
            return
        }
        
        isLoading = true
        
        let request = LoginRequest(
            email: email,
            password: password,
            deviceId: sessionManager.getDeviceId() ?? "",
            appVersion: Config.version,
            phoneOsVersion: Config.osVersion,
            phoneType: sessionManager.getDeviceModel()
        )
        
        interactor.login(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorAlertMessage = error.localizedDescription
                    self.errorAlert = true
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.sessionManager.storeLogInData(
                    accessToken: response.accessToken
                )
                self.sessionManager.updateState()
            })
            .store(in: &cancellables)
    }
    
    func validateEmail(email: String) -> Bool {
        if !email.isValidEmail() {
            return false
        }
        return true
    }
    
    private func onEmailChange() {
        errorEmailMessage = nil
    }
    
    private func onPasswordChange() {
        errorPasswordMessage = nil
    }
}

