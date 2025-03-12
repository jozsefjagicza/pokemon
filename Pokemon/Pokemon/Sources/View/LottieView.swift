//
//  LottieView.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 12..
//

import SwiftUI
import Lottie
import UIKit

struct LottieView: View {
    var animationName: String
    
    @State private var animationView = LottieAnimationView()
    
    var body: some View {
        ZStack {
            LottieViewRepresentable(animationName: animationName)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct LottieViewRepresentable: UIViewRepresentable {
    var animationName: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: animationName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            animationView.frame = CGRect(x: (UIScreen.main.bounds.width - 50) / 2,
                                         y: (UIScreen.main.bounds.height - 50) / 2,
                                         width: 50, height: 50)
            animationView.contentMode = .scaleAspectFit
            view.addSubview(animationView)
            animationView.play { (finished) in
                if finished {
                    print("Animation finished")
                } else {
                    print("Animation failed or was interrupted")
                }
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Handle updates here
    }
}
