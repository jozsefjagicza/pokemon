//
//  HomeCoordinator.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Stinsen
import SwiftUI

protocol HomeCoordinatorProtocol {
    func routeToHome()
    func routeToDetails()
    func backToHome()
}

final class HomeCoordinator: NavigationCoordinatable, HomeCoordinatorProtocol {
    var stack: Stinsen.NavigationStack<HomeCoordinator>
    
    @Root var home = makeHome
    @Route(.push) var details = makeDetails

    init() {
        self.stack = NavigationStack(initial: \.home)
    }

    func makeHome() -> some View {
        HomeView()
    }

    func makeDetails() -> some View {
        PokemonDetailsView()
    }

    func routeToHome() {
        self.root(\.home)
    }

    func routeToDetails() {
        self.route(to: \.details)
    }

    func backToHome() {
        self.popLast()
    }
}

