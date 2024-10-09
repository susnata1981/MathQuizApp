//
//  ReviewResultView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import SwiftUI

struct ReviewResultView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    
    @State var currIndex: Int
    @State var currProblem: Problem
    @State var startNewGame = false
    
    var quiz: Quiz
    
    init(quiz: Quiz) {
        self.quiz = quiz
        self.currIndex = 0
        self.currProblem = quiz.getProblem(index: 0)
    }
    
    var body: some View {
        let _ = print("ReviewResultView: body")
        
        VStack {
            ProblemSectionView(indexOfProblem: currIndex, problem: currProblem, quiz: quiz)
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(radius: 10)
            
            HStack {
                MyMultiChoiceView(problem: currProblem, quiz: quiz, isReviewMode: true)
            }.padding()
            
            Spacer()
            
            Text("Correct Answer is \(currProblem.answer)")
                .font(.custom("Comic Sans MS", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            Spacer()
            
            nextButtonView
        }
//        .onAppear {
//            let _ = print("ReviewResultView: onAppear")
//            print("Path = \(navigationManager.path) \(navigationManager.path.count)")
//        }
//        .navigationDestination(isPresented: $startNewGame) {
//            let _ = print("ReviewResultView: navigationDestination \(startNewGame) \(navigationManager.path.count)")
//            CompletedReviewView()
//        }
    }
    
    var nextButtonView: some View {
        
            Button(action: {
                currIndex = currIndex + 1
                if currIndex < quiz.getProblemCount() {
                    currProblem = quiz.getProblem(index: currIndex)
                } else {
//                    startNewGame = true
                    navManager.gotoCompleteReview()
                }
            }) {
                Text("Next")
                    .font(.custom("Comic Sans MS", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }.primaryButtonStyle()
    }
}

