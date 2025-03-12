//
//  LaunchViewModel.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import Foundation
import Stinsen

class LaunchViewModel: ObservableObject {
    
    @Injected private var sessionManager: SessionManagerType

    @Published var sizePercent: CGFloat = 0.1
    @Published var opacityPercent: Double = 0.1
    
    func loadInitView() {
        sessionManager.updateState()
    }
}

