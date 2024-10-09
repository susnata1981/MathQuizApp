//
//  ReviewResultsComplete.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import SwiftUI

struct CompletedReviewView: View {
    var body: some View {
        Text("Completed!")
        
        NavigationLink("Take another quiz", destination: {
            StartQuizView()
        })
    }
}

#Preview {
    ReviewResultsComplete()
}
