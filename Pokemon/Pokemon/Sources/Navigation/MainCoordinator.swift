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
    func makeAuthenticated() -> NavigationViewCoordinator<HomeCoordinator>

}

final class MainCoordinator: NavigationCoordinatable, MainCoordinatorProtocol {
    var stack = NavigationStack(initial: \MainCoordinator.splash)
    
    private var cancellables: Set<AnyCancellable>
    
    @Injected var sessionManager: SessionManagerType
    
    @Root var unauthenticated = makeUnauthenticated
    @Root var authenticated = makeAuthenticated

    @Root var splash = makeSplash
    
    var homeCoordinator: HomeCoordinator?

    func makeUnauthenticated() -> NavigationViewCoordinator<LoginCoordinator> {
        let loginCoordinator = LoginCoordinator()
        return NavigationViewCoordinator(loginCoordinator)
    }
    
    func makeAuthenticated() -> NavigationViewCoordinator<HomeCoordinator> {
        if homeCoordinator == nil {
            homeCoordinator = HomeCoordinator()
            }
        return NavigationViewCoordinator(homeCoordinator!)
        }
    
    func makeSplash() -> some View {
        LaunchView()
    }
    
    func getHomeCoordinator() -> HomeCoordinatorProtocol {
            if homeCoordinator == nil {
                homeCoordinator = HomeCoordinator()
            }
            return homeCoordinator!
        }
    
    init() {
        cancellables = Set<AnyCancellable>()
        sessionManager.stateSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] status in
                switch status {
                case .loggedIn:
                    self?.root(\.authenticated)
                case .loggedOut:
                    self?.root(\.unauthenticated)
                }
            }
            .store(in: &cancellables)
    }
}

