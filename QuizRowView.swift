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
        ZStack {
            theme.colors.primary.opacity(0.4).edgesIgnoringSafeArea(.all)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(quiz.getCreatedAtDate())
                        .font(theme.fonts.small)
                        .fontWeight(.heavy)
                        .foregroundColor(theme.colors.background)
                    
                    HStack {
                        Text("status")
                            .font(theme.fonts.small)
                            .foregroundColor(.gray)
                            .foregroundColor(theme.colors.background)
                        
                        Text("\(quiz.status.rawValue)")
                            .font(theme.fonts.regular)
                            .foregroundColor(theme.colors.background)
                    }
                }
                
                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Image(systemName: quiz.getPercentageScore >= 80 ? "hand.thumbsup.fill": "hand.thumbsdown.fill")
                        .foregroundColor(quiz.getPercentageScore >= 80 ? theme.colors.primary.opacity(0.8) : theme.colors.error)

                    HStack {
                        Text("score")
                            .font(theme.fonts.small)
                            .foregroundColor(.gray)
                        
                        Text("\(quiz.getPercentageScore)%")
                            .font(theme.fonts.bold)
                            .foregroundColor(theme.colors.background)
                    }
                }
                
                
            }.padding()
        }
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

struct QuizRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // High score quiz
            QuizRowView(quiz: mockQuiz(score: 90, status: .completed))
                .environmentObject(Theme.theme1)
                .previewDisplayName("High Score")
            
            // Medium score quiz
            QuizRowView(quiz: mockQuiz(score: 70, status: .completed))
                .environmentObject(Theme.theme1)
                .previewDisplayName("Medium Score")
            
            // Low score quiz
            QuizRowView(quiz: mockQuiz(score: 40, status: .completed))
                .environmentObject(Theme.theme1)
                .previewDisplayName("Low Score")
            
            // In-progress quiz
            QuizRowView(quiz: mockQuiz(score: 0, status: .inProgress))
                .environmentObject(Theme.theme1)
                .previewDisplayName("In Progress")
            
            // Dark mode
            QuizRowView(quiz: mockQuiz(score: 80, status: .completed))
                .environmentObject(Theme.theme1)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
    
    static func mockQuiz(score: Int, status: CompletionStatus) -> Quiz {
        let quiz = Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 10)
        quiz.status = status
        quiz.score = Score(totalCorrect: score, totalIncorrect: 10 - score)
        quiz.createdAt = Date()
        return quiz
    }
}

