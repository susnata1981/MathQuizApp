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
                    .font(.system(size: 60))
                    .foregroundColor(theme.colors.success)
                    .opacity(showAnimation ? 1 : 0)
                    .scaleEffect(showAnimation ? 1 : 0.5)
                
                Button(action: navigationManager.gotoProfile) {
                    Text("Back")
                        .foregroundColor(theme.colors.background)
                        .padding(16)
                        .background(theme.colors.primary)
                        .cornerRadius(10)
                }
                
                
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
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
            .environmentObject(Theme.theme1)
            .colorScheme(.dark)
    }
}
