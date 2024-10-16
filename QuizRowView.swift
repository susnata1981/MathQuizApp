//
//  QuizRowView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 10/13/24.
//

import SwiftUI

struct QuizRowView: View {
    @EnvironmentObject var theme: Theme
    let quiz: Quiz
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(quiz.getCreatedAtDate())
                    .font(theme.fonts.small)
                    .foregroundColor(theme.colors.secondary)
                
                Text("Status: \(quiz.status.rawValue)")
                    .font(theme.fonts.regular)
                    .foregroundColor(theme.colors.text)
            }
            
            Spacer()
            
            Text("Score: \(quiz.getPercentageScore)%")
                .font(theme.fonts.bold)
                .foregroundColor(scoreColor)
        }
        .padding(.vertical, 8)
    }
    
    private var scoreColor: Color {
        let score = quiz.getPercentageScore
        if score >= 80 {
            return theme.colors.success
        } else if score >= 60 {
            return theme.colors.error
        } else {
            return theme.colors.error
        }
    }
}

//#Preview {
//    QuizRowView()
//}
