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
            switch(self) {
                case .right: 10
                case .left: -10
                case .start: 0
            }
        }
    }
    
    @EnvironmentObject var quizVM: QuizViewModel
    var quiz: Quiz
    
    @State var isWrongAnswer = false
    @State var bounce = true
    
    var isReviewMode = false
    var item: MultiChoiceItem
    var problem: Problem

    var body: some View {
        
        Group {
            Button(action: {
                quizVM.handleChoiceSelection(choice: item)
                isWrongAnswer = !quizVM.isSelectionCorrect(item)
            }) {
                Text(item.content)
                    .font(.custom("Comic Sans MS", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(
                        quizVM.isChoiceSelected(item) ? quizVM.defaultTextColor : quizVM.selectedTextColor)
                    .frame(width: 120, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(fillColor(item))
                            .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 3)
                    )
            }
            .disabled(quizVM.isChoiceSelected(item) || isReviewMode)
            .phaseAnimator(getShakeAnimationStates(), trigger: isWrongAnswer, content: { content, phase in
                return content.offset(x: CGFloat(phase.offset))
            }, animation: { phase in
                return .easeIn(duration: 0.3).speed(5.0)
            })
        }
    }
    
    func getShakeAnimationStates() -> Array<Shake> {
        var states = Array(repeating: Shake.allCases, count: 3).flatMap{ $0 }.filter{
            $0 != .start
        }
        states.insert(.start, at: 0)
        states.append(.start)
        return states
    }
    
    func fillColor(_ item: MultiChoiceItem) -> Color {
        return quizVM.isChoiceSelected(item) ? quizVM.selectedChoiceBackgroundColor : Color.white
    }
    
//    private func didUserSelect(_ problem: Problem, _ item: MultiChoiceItem) -> Bool {
//        let answer = quiz.answers.filter{ $0.key == problem.id }.first?.value
//        if answer != nil && item.content == answer! {
//            return true
//        }
//        
//        return false
//    }
    
//    private func isSelectionCorrect(_ choice: MultiChoiceItem) -> Bool {
//        return problem.isAnswerCorrect(userInput: choice.content)
//    }
}

//#Preview {
//    ChoiceRowView()
//}
