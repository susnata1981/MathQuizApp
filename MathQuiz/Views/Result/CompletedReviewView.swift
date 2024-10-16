//
//  CompletedReviewView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import SwiftUI

struct CompletedReviewView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var theme: Theme
    @State private var showAnimation = false
    
    var body: some View {
        ZStack {
            theme.colors.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Review Completed!")
                    .font(theme.fonts.large)
                    .foregroundColor(theme.colors.primary)
                    .opacity(showAnimation ? 1 : 0)
                    .scaleEffect(showAnimation ? 1 : 0.5)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(theme.colors.success)
                    .opacity(showAnimation ? 1 : 0)
                    .scaleEffect(showAnimation ? 1 : 0.5)
                
                StandardButton(title: "Start Another Quiz", action: navigationManager.gotoHome)
                    .opacity(showAnimation ? 1 : 0)
                    .offset(y: showAnimation ? 0 : 20)
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)) {
                showAnimation = true
            }
        }
    }
}

struct CompletedReviewView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedReviewView()
            .environmentObject(NavigationManager())
            .environmentObject(Theme.theme1) // Use your default theme here
    }
}
