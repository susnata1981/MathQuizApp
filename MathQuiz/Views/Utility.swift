//
//  Utility.swift
//  MathQuiz
//
//  Created by Susnata Basak on 10/1/24.
//

import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .bold))
            .padding()
            .foregroundColor(.white)
            .background(.pink.opacity(0.7))
            .cornerRadius(5.0)
    }
}

struct SecondaryButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .bold))
            .padding()
            .foregroundColor(.white)
            .background(.pink.opacity(0.4))
            .cornerRadius(5.0)
    }
}

extension View {
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
    
    func secondaryButtonStyle() -> some View {
        self.modifier(SecondaryButtonModifier())
    }
}
