//
//  ChoiceRowView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import SwiftUI

struct ChoiceRowView: View {
    enum Shake: CaseIterable {
        case start, right, left

        var offset: Int {
            switch self {
            case .right: 10
            case .left: -10
            case .start: 0
            }
        }
    }
    
    @EnvironmentObject var quizVM: QuizViewModel
    @EnvironmentObject var theme: Theme
    var quiz: Quiz
    
    @State var isWrongAnswer = false
    @State var bounce = true
    
    var isReviewMode = false
    var item: MultiChoiceItem
    var problem: Problem

    var body: some View {
        Button(action: {
            quizVM.handleChoiceSelection(choice: item)
            isWrongAnswer = !quizVM.isSelectionCorrect(item)
        }) {
            Text(item.content)
                .font(theme.fonts.large)
                .fontWeight(.bold)
                .foregroundColor(quizVM.isChoiceSelected(item) ? theme.colors.background : theme.colors.accent)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(fillColor(item))
                .cornerRadius(8)
                .padding(8)
        }
        .disabled(quizVM.isChoiceSelected(item) || isReviewMode)
        .phaseAnimator(getShakeAnimationStates(), trigger: isWrongAnswer) { content, phase in
            content.offset(x: CGFloat(phase.offset))
        } animation: { _ in
            .easeIn(duration: 0.3).speed(5.0)
        }
    }
    
    func getShakeAnimationStates() -> [Shake] {
        var states = Array(repeating: Shake.allCases, count: 3).flatMap { $0 }.filter { $0 != .start }
        states.insert(.start, at: 0)
        states.append(.start)
        return states
    }
    
    func fillColor(_ item: MultiChoiceItem) -> Color {
        quizVM.isChoiceSelected(item) ? theme.colors.accent.opacity(0.4) : theme.colors.background.opacity(0.4)
    }
}

struct ChoiceRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChoiceRowView(
            quiz: Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 3),
            item: MultiChoiceItem(id: 1, content: "10"),
            problem: Problem(num1: 1, num2: 2, operation: .add)
        )
        .environmentObject(QuizViewModel())
        .environmentObject(Theme.theme1)
        .colorScheme(.dark)
    }
}
