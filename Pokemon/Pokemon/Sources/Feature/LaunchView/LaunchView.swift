//
//  LaunchView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import SwiftUI
import Stinsen

struct LaunchView: View {

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                HStack {
                    LottieView(animationName: "pokemon.json")
                        .scaleEffect(4)
                        .accessibilityIdentifier("loadingView")
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
