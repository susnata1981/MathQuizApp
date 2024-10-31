//
//  MyMultiChoiceView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import SwiftUI

struct MyMultiChoiceView: View {
    
    @EnvironmentObject var theme: Theme
    var problem: Problem
    var quiz: Quiz
    var isReviewMode = false
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(problem.multiChoiceItems, id: \.self) { choice in
                if isReviewMode {
                    ReviewChoiceRowView(
                        quiz: quiz,
                        problem: problem,
                        item: choice)
                } else {
                    ChoiceRowView(
                        quiz: quiz,
                        isReviewMode: isReviewMode,
                        item: choice,
                        problem: problem)
                }
            }
        }
    }
}

struct ReviewChoiceRowView: View {
    @EnvironmentObject var theme: Theme
    var quiz: Quiz
    var problem: Problem
    var item: MultiChoiceItem
    
    var body: some View {
        Button(action: {}) {
            Text(item.content)
                .font(theme.fonts.large)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 40)
                .padding(4)
                .background(fillBackgroundColor(item))
                .cornerRadius(8)
        }
        .disabled(true)
    }
    
    func fillForegroundColor(_ item: MultiChoiceItem) -> Color {
        if didUserSelect(problem, item) {
            return .white
        } else {
            return theme.colors.text
        }
    }
    
    
    func fillBackgroundColor(_ item: MultiChoiceItem) -> Color {
        if didUserSelect(problem, item) {
            return String(problem.answer) == item.content ? theme.colors.success : theme.colors.error
        } else {
            return Color.gray.opacity(0.4)
        }
    }
    
    private func didUserSelect(_ problem: Problem, _ item: MultiChoiceItem) -> Bool {
        let answer = quiz.answers.filter { $0.key == problem.id }.first?.value
        return answer != nil && item.content == answer
    }
}

