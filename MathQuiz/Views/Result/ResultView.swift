//
//  ResultView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/31/24.
//

import SwiftUI

struct ResultView: View {
    
//    @Environment(QuizViewModel.self) var quizVM: QuizViewModel
    @EnvironmentObject var quizVM: QuizViewModel
    @EnvironmentObject var session: Session
    
    @State private var startNewGame = false
    @State private var reviewResult = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Results: ")
                .font(.largeTitle)
            
            Text("Total correct: \(session.score.0)")
            Text("Total incorrect: \(session.score.1)")
            
            Spacer()
            
            Button("New Game") {
                session.resetQuiz()
                startNewGame = true
            }
            
            Button("Review Result") {
//                session.resetQuiz()
                reviewResult = true
            }
            
            Spacer()
        }.onAppear {
            Task {
                await session.saveScore()
            }
        }.navigationDestination(isPresented: $startNewGame) {
            StartQuizView()
        }.navigationDestination(isPresented: $reviewResult) {
            ReviewResultView()
        }.navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    var q = Quiz(
//        operation: MathOperation.add,
//        difficultyLevel: DifficultyLevel.easy,
//        numProblems: 5)
//    
//    return ResultView(session: .init(
//        user: User(uid: "AAA", name: "Adi"),
//        quiz: q)).environment(QuizViewModel())

//}
