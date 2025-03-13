//
//  View+Extension.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import SwiftUI

extension View {
    func hideKeyboard() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
        keyWindow?.endEditing(true)
    }
}
