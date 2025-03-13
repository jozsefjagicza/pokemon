//
//  Logininteractor.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation
import Combine

protocol LoginInteractorProtocol {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error>
}

enum LoginValidationResult {
    case success
    case failure(emailError: String?, passwordError: String?)
}

class LoginInteractor: LoginInteractorProtocol {
    private let mockDatabase = [User(id: 1000, email: "user1@gmail.com", name: "Teszt User1", password: "password123")]
    
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        return Just(request)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .tryMap { [weak self] request -> LoginResponse in
                guard let self = self else { throw LoginError.unknown }
                
                guard let user = self.mockDatabase.first(where: { $0.email == request.email }) else {
                    throw LoginError.invalidCredentials
                }
                
                guard user.password == request.password else {
                    throw LoginError.invalidCredentials
                }
                
                guard request.email.isValidEmail() else {
                    throw LoginError.invalidEmail
                }
                
                return LoginResponse(
                    user: user,
                    accessToken: "AccessToken"
                )
            }
            .eraseToAnyPublisher()
    }
}
