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
                .fontWeight(.bold)
                .foregroundColor(fillForegroundColor(item))
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(fillBackgroundColor(item))
                .cornerRadius(8)
                .padding(8)
//                .background(
//                    RoundedRectangle(cornerRadius: 15)
//                        .fill(fillBackgroundColor(item))
//                        .shadow(color: theme.colors.primary.opacity(0.3), radius: 5, x: 0, y: 3)
//                )
        }
        .disabled(true)
    }
    
    func fillForegroundColor(_ item: MultiChoiceItem) -> Color {
        if didUserSelect(problem, item) {
            return theme.colors.background
        } else {
            return theme.colors.accent
        }
    }
    
    
    func fillBackgroundColor(_ item: MultiChoiceItem) -> Color {
        if didUserSelect(problem, item) {
            return String(problem.answer) == item.content ? theme.colors.accent.opacity(0.4) : theme.colors.background.opacity(0.4)
        } else {
            return theme.colors.background.opacity(0.4)
        }
    }
    
    private func didUserSelect(_ problem: Problem, _ item: MultiChoiceItem) -> Bool {
        let answer = quiz.answers.filter { $0.key == problem.id }.first?.value
        return answer != nil && item.content == answer!
    }
}

struct MyMultiChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        MyMultiChoiceView(
            problem: Problem(num1: 5, num2: 3, operation: .add),
            quiz: Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 3)
        )
        .environmentObject(Theme.theme1) // Use your default theme here
    }
}
