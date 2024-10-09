//
//  CompletedReviewView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import SwiftUI

struct CompletedReviewView: View {
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        let _ = print("CompletedReviewView body")
        Text("Completed! \(navigationManager.path.count)")
        
        Button(action: {
            navigationManager.gotoHome()
        }) {
            Text("Start Another Quiz")
                .font(.title3)
        }
    }
}

#Preview {
    CompletedReviewView()
}
