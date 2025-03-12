//
//  LoginCoordinator.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import Stinsen
import SwiftUI

final class LoginCoordinator: NavigationCoordinatable {
    var stack: Stinsen.NavigationStack<LoginCoordinator>
    
    @Root var login = makeLogin

    init() {
        stack = NavigationStack(initial: \LoginCoordinator.login)
    }

    func makeLogin() -> LoginView {
        LoginView()
    }
}

