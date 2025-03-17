//
//  ConnectionStatusView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 17..
//

import SwiftUI

struct ConnectionStatusView: View {
    let isConnected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isConnected ? "wifi" : "wifi.slash")
                .foregroundColor(isConnected ? .green : .red)
            Text(isConnected ? "Online" : "Offline")
                .font(.caption)
                .foregroundColor(isConnected ? .green : .red)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
