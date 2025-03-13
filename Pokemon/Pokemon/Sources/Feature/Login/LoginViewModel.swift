//
//  LoginViewModel.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import SwiftUI

class LoginViewModel: ObservableObject {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            if self.email == "user@example.com" && self.password == "password" {
                print("Sikeres bejelentkezés!")
            } else {
                self.errorAlert = true
                self.errorAlertMessage = "Hibás email vagy jelszó"
            }
        }
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

