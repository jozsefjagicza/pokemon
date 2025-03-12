//
//  Injected.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//


import SwiftUI
import Combine
import Swinject

@propertyWrapper
struct Injected<T> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = AppContainer.shared.container.resolve(T.self)!
    }
}

@propertyWrapper
struct InjectedObject<T>: DynamicProperty where T: ObservableObject {
    @ObservedObject private var service: T
    
    public init() {
        guard let resolved = AppContainer.shared.container.resolve(T.self) else {
            fatalError("Dependency for \(T.self) could not be resolved.")
        }
        self.service = resolved
    }
    
    public var wrappedValue: T {
        get { return service }
        mutating set { service = newValue }
    }
    
    public var projectedValue: ObservedObject<T>.Wrapper {
        return self.$service
    }
}
