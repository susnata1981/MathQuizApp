//
//  MyCountDownView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/15/24.
//

import SwiftUI

struct MyCountDownView: View {
    @EnvironmentObject var theme: Theme
    @State private var count: Int = 3
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0
    @Binding var showCountdown: Bool
    var completion: () -> Void
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var content: String {
        count == 0 ? "Go!" : String(count)
    }
    
    private var color: Color {
        count == 0 ? theme.colors.accent : theme.colors.primary
    }

    var body: some View {
        ZStack {
            
            Circle()
                .fill(color.opacity(0.3))
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
                .opacity(opacity)
            
            Text(content)
                .font(theme.fonts.large.weight(.bold))
                .foregroundColor(color)
                .scaleEffect(scale)
                .opacity(opacity)
                .rotationEffect(.degrees(rotation))
            
            Circle()
                .stroke(color.opacity(0.5), lineWidth: 5)
                .frame(width: 220, height: 220)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                if count > 0 {
                    count -= 1
                    animateNumber()
                } else {
                    opacity = 0
                    scale = 0.5
                }
            }
            
            if count <= 0 {
                showCountdown = false
                completion()
            }
        }
        .onAppear {
            animateNumber()
        }
    }
    
    private func animateNumber() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
            scale = 1
            opacity = 1
            rotation = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeInOut(duration: 0.3)) {
                scale = 0.7
                opacity = 0
                rotation = -90
            }
        }
    }
}

struct MyCountDownView_Previews: PreviewProvider {
    static var previews: some View {
        MyCountDownView(showCountdown: .constant(true), completion: {})
            .environmentObject(Theme.theme1) // Use your default theme here
    }
}
