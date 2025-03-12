//
//  MainCoordinator.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import Combine
import Foundation
import SwiftUI
import Stinsen

protocol MainCoordinatorProtocol {
    
    func makeUnauthenticated() -> NavigationViewCoordinator<LoginCoordinator>

}

final class MainCoordinator: NavigationCoordinatable, MainCoordinatorProtocol {
    var stack = NavigationStack(initial: \MainCoordinator.splash)
    
    private var cancellables: Set<AnyCancellable>
    
    @Injected var sessionManager: SessionManagerType
    
    @Root var unauthenticated = makeUnauthenticated
    @Root var splash = makeSplash
    
    func makeUnauthenticated() -> NavigationViewCoordinator<LoginCoordinator> {
        let loginCoordinator = LoginCoordinator()
        return NavigationViewCoordinator(loginCoordinator)
    }
    
    func makeSplash() -> some View {
        LaunchView()
    }
    
    init() {
        cancellables = Set<AnyCancellable>()
        sessionManager.stateSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] status in
                switch status {
                case .loggedIn:
                    self?.root(\.unauthenticated)
                case .loggedOut:
                    self?.root(\.unauthenticated)
                }
            }
            .store(in: &cancellables)
    }
}

