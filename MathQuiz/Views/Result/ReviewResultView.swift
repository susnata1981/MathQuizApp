//
//  ReviewResultView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import SwiftUI

struct ReviewResultView: View {
    @EnvironmentObject var quizNavManager: NavigationManager
    @EnvironmentObject var theme: Theme
    
    @State private var currIndex: Int
    @State private var currProblem: Problem
    
    let quiz: Quiz
    
    init(quiz: Quiz) {
        self.quiz = quiz
        self._currIndex = State(initialValue: 0)
        self._currProblem = State(initialValue: quiz.getProblem(index: 0))
    }
    
    var body: some View {
        VStack {
            ProblemSectionView(indexOfProblem: currIndex, problem: currProblem, quiz: quiz)
                .padding()
            
            MyMultiChoiceView(problem: currProblem, quiz: quiz, isReviewMode: true)
                .padding()
            
            Spacer()
            
            Text("Correct Answer is \(currProblem.answer)")
                .font(theme.fonts.large)
                .fontWeight(.bold)
                .foregroundColor(theme.colors.primary)
            
            Spacer()
            
            nextButtonView
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
    
    private var nextButtonView: some View {
        StandardButton(title: "Next", action: handleNextButtonTap)
    }
    
    private func handleNextButtonTap() {
        currIndex += 1
        if currIndex < quiz.getProblemCount() {
            currProblem = quiz.getProblem(index: currIndex)
        } else {
            quizNavManager.gotoCompleteReview()
        }
    }
}

struct ReviewResultView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewResultView(quiz: Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 3))
            .environmentObject(NavigationManager())
            .environmentObject(Theme.theme1) // Use your default theme here
    }
}
