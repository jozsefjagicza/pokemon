//
//  AppContainer.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import Foundation
import Swinject

public final class AppContainer {
    public static var shared = AppContainer()
    
    public var container: Container!
    
    func setProductionContainer() {
        container = Container()
        
        container.register(MainCoordinator.self) { _ in
            MainCoordinator()
        }
        .inObjectScope(.container)
        
        container.register(MainCoordinatorProtocol.self) { resolver in
            resolver.resolve(MainCoordinator.self)!
        }
        .inObjectScope(.container)
        
        container.register(HomeCoordinatorProtocol.self) { resolver in
                let mainCoordinator = resolver.resolve(MainCoordinator.self)!
                return mainCoordinator.getHomeCoordinator()
            }
            .inObjectScope(.container)
        
        container.register(SessionManagerType.self) { _ in
            SessionManager()
        }
        .inObjectScope(.container)
        
        container.register(SettingsManager.self) { _ in
            SettingsManager.shared
        }
        .inObjectScope(.container)
        
        container.register(LoginInteractorProtocol.self) { _ in
            LoginInteractor()
        }
        .inObjectScope(.container)
        
        container.register(HomeInteractorProtocol.self) { _ in
            HomeInteractor()
        }
        .inObjectScope(.container)
        
        container.register(PokemonInteractorProtocol.self) { _ in
            PokemonInteractor()
        }
        .inObjectScope(.container)
    }
}

