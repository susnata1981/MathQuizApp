//
//  ResultView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/31/24.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var quizVM: QuizViewModel
    @EnvironmentObject var session: Session
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var startNewGame = false
    @State private var reviewResult = false
    
    private var score: Int {
        get {
            let (tc, ti) = session.score
            return (100 * tc)/(tc + ti)
        }
    }
    
    enum Destination2: Hashable {
        case ReviewResultView(quiz: Quiz)
        case StartQuizView
        case CompleteReview
    }
    
    
    var body: some View {
        let _ = print("ResultView init")
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                resultHeader
                scoreCard
                actionButtons
            }
            .padding()
        }
        //        .navigationDestination(for: Destination2.self) { destination in
        //            let _ = print("ResultView: navigationDestination - \(destination)")
        //
        //            switch destination {
        //            case .ReviewResultView(let quiz):
        //                ReviewResultView(quiz: quiz)
        //            case .StartQuizView:
        //                StartQuizView()
        //            case .CompleteReview:
        //                CompletedReviewView()
        //            }
        //        }
        .navigationDestination(isPresented: $startNewGame) {
            StartQuizView()
        }
        .onAppear {
            Task { await session.saveScore() }
        }
        .navigationDestination(isPresented: $reviewResult) {
            ReviewResultView(quiz: session.quiz!)
        }
    }
    
    private var resultHeader: some View {
        Text("Quiz Results")
            .font(.system(size: 36, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .padding(.top, 50)
    }
    
    private var scoreCard: some View {
        VStack(spacing: 20) {
            HStack {
                Text("You scored")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("\(score)%")
                    .font(.system(size: 72.0))
                    .foregroundColor(score > 70 ? .cyan : .red.opacity(0.8))
                    .fontWeight(.bold)
            }
        }.padding()
    }
    
    private func scoreRow(title: String, score: Int, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text("\(score)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 15) {
            Button(action: { startNewGame = true }) {
                Text("Start New Game")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("primary"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: { reviewResult = true }) {
                Text("Review Results")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color("primary"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary, lineWidth: 2)
                    )
            }
        }
        .padding(.bottom, 50)
    }
}

//#Preview {
//
//    return ResultView()
//        .environmentObject(QuizViewModel())
//        .environmentObject(Session())
//
//}
