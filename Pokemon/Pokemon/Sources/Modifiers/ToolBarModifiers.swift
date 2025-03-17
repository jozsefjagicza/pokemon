//
//  ToolBarModifiers.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 17..
//

import SwiftUI

struct FavoriteToolbarModifier: ViewModifier {
    
    var favoriteAction: (() -> Void)
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.favoriteAction()
                    }) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
    }
}

struct StatusToolbarModifier: ViewModifier {
    @Binding var reachability: ReachabilityService
    
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .status) {
                    HStack {
                        Image(systemName: reachability.isConnected ? "wifi" : "wifi.slash")
                            .foregroundColor(reachability.isConnected ? .green : .red)
                        Text(reachability.isConnected ? "Online" : "Offline")
                            .font(.caption)
                            .foregroundColor(reachability.isConnected ? .green : .red)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
    }
}


