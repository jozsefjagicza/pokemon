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
    func routeToDetails(pokemon: Pokemon)
    func routeToFavorites()
    func backToHome()
}

final class HomeCoordinator: NavigationCoordinatable, HomeCoordinatorProtocol {
    var stack: Stinsen.NavigationStack<HomeCoordinator>
    
    @Root var home = makeHome
    @Route(.push) var details = makeDetails
    @Route(.push) var favorites = makeFavorites
    
    init() {
        self.stack = NavigationStack<HomeCoordinator>(initial: \.home)
    }

    func makeHome() -> some View {
        HomeView()
    }

    func makeDetails(pokemon: Pokemon) -> some View {
        PokemonDetailsView(pokemon: pokemon)
    }

    func routeToHome() {
        self.root(\.home)
    }

    func routeToDetails(pokemon: Pokemon) {
        self.route(to: \.details, pokemon)
    }
    
    func makeFavorites() -> some View {
        FavoritesView()
    }

    func routeToFavorites() {
        self.route(to: \.favorites)
    }
    
    func backToHome() {
        self.popLast()
    }
}

