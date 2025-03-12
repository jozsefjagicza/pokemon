//
//  LaunchView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import SwiftUI
import Stinsen

struct LaunchView: View {

    @StateObject private var viewModel: LaunchViewModel = LaunchViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                HStack {
                    LottieView(animationName: "pokemon.json")
                        .scaleEffect(4)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.viewModel.loadInitView()
            }
        }
    }
}
