//
//  MyMultiChoiceView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

//import SwiftUI
//
//struct MyMultiChoiceView: View {
//    var problem: Problem
//    var quiz: Quiz
//    var isReviewMode = false
//    
//    var body: some View {
//        VStack(spacing: 15) {
//            ForEach(problem.multiChoiceItems, id: \.self) { choice in
//                if (isReviewMode) {
//                    ReviewChoiceRowView(
//                        quiz: quiz,
//                        problem: problem,
//                        item: choice)
//                } else {
//                    ChoiceRowView(
//                        quiz: quiz,
//                        isReviewMode: isReviewMode,
//                        item: choice,
//                        problem: problem)
//                }
//            }
//        }
//    }
//}
//
//struct ReviewChoiceRowView: View {
//    var quiz: Quiz
//    var problem: Problem
//    var item: MultiChoiceItem
//    
//    var body: some View {
//        Group {
//            Button(action: {
//            }) {
//                Text(item.content)
//                    .font(.custom("Comic Sans MS", size: 24))
//                    .fontWeight(.bold)
//                    .foregroundColor(.purple)
//                    .frame(width: 120, height: 60)
//                    .background(
//                        RoundedRectangle(cornerRadius: 15)
//                            .fill(fillColor(item))
//                            .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 3)
//                    )
//            }
//            .disabled(true)
//        }
//    }
//    
//    func fillColor(_ item: MultiChoiceItem) -> Color {
//        if didUserSelect(problem, item) {
//            return String(problem.answer) == item.content ? .green : .red
//        } else {
//            return .white
//        }
//    }
//    
//    private func didUserSelect(_ problem: Problem, _ item: MultiChoiceItem) -> Bool {
//        let answer = quiz.answers.filter{ $0.key == problem.id }.first?.value
//        if answer != nil && item.content == answer! {
//            return true
//        }
//        
//        return false
//    }
//}

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
                .foregroundColor(theme.colors.text)
                .frame(width: 120, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(fillColor(item))
                        .shadow(color: theme.colors.primary.opacity(0.3), radius: 5, x: 0, y: 3)
                )
        }
        .disabled(true)
    }
    
    func fillColor(_ item: MultiChoiceItem) -> Color {
        if didUserSelect(problem, item) {
            return String(problem.answer) == item.content ? theme.colors.success : theme.colors.error
        } else {
//            return theme.colors.background
            return .white
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
