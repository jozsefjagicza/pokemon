//
//  FavoritesView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 17..
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        VStack {
            
            Spacer()
        }
        .navigationTitle("Favorites")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.backToHome()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

