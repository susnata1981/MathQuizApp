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
        
        ZStack {
            theme.colors.background.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                progressBar
                    .padding(.top)
                
                ProblemSectionView(indexOfProblem: currIndex, problem: currProblem, quiz: quiz)
                    .frame(minHeight: 180)
                
                HStack(alignment: .center) {
                    Text("Answer is ")
                        .font(theme.fonts.regular)
                        .foregroundColor(theme.colors.text)
                    
                    Text("\(currProblem.answer)")
                        .font(theme.fonts.xlarge)
                        .foregroundColor(theme.colors.text)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
                .cornerRadius(8)
                .padding()
                
                
                VStack {
                    MyMultiChoiceView(problem: currProblem, quiz: quiz, isReviewMode: true)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            StandardButton(title: "Prev", action: handlePrevButtonTap, style: SecondaryButtonStyle())
                            
                            nextButtonView
                        }
                        
                        Button(action: { quizNavManager.gotoHome() }) {
                            Text("Go Back")
                                .font(.subheadline)
                                .foregroundColor(theme.colors.accent)
                        }.padding(.top)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    var progressBar: some View {
        VStack(spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(theme.colors.primary.opacity(0.3))
                        .frame(height: 8)
                    
                    Rectangle()
                        .fill(theme.colors.primary)
                        .frame(width: progressWidth(for: geometry.size.width), height: 8)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
            
            Text("\(currIndex + 1) of \(quiz.getProblemCount())")
                .font(theme.fonts.caption)
                .foregroundColor(theme.colors.text)
        }
        .padding(.horizontal)
    }
    
    func progressWidth(for totalWidth: CGFloat) -> CGFloat {
        let progress = CGFloat(currIndex + 1) / CGFloat(quiz.getProblemCount())
        return totalWidth * progress
    }
    
    private var nextButtonView: some View {
        StandardButton(title: "Next", action: handleNextButtonTap, style: PrimaryButtonStyle())
    }
    
    private func handleNextButtonTap() {
        if currIndex < quiz.getProblemCount() - 1 {
            currIndex += 1
            currProblem = quiz.getProblem(index: currIndex)
        } else {
            quizNavManager.gotoCompleteReview()
        }
    }
    
    private func handlePrevButtonTap() {
        if currIndex > 0 {
            currIndex -= 1
            currProblem = quiz.getProblem(index: currIndex)
        }
    }
}


struct ReviewResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReviewResultView(quiz: Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 3))
                .environmentObject(NavigationManager())
                .environmentObject(Theme.theme5)
                .colorScheme(.light)
                .previewDisplayName("Light Mode")
            
            ReviewResultView(quiz: Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 3))
                .environmentObject(NavigationManager())
                .environmentObject(Theme.theme1)
                .colorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
