////
////  ContentView.swift
////  MathQuiz
////
////  Created by Susnata Basak on 8/30/24.
////
//


import SwiftUI

struct QuizView: View {
    @StateObject var quizVM = QuizViewModel()
    @EnvironmentObject var session: Session
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var theme: Theme
    
    @State var shake = false
    
    struct Constants {
        static let totalProblems = 3
        static let multiChoiceCount = 4
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                ProblemSectionView(
                    indexOfProblem: quizVM.ctx.currentIndex,
                    problem: quizVM.currentProblem,
                    quiz: quizVM.quiz)
                
                HStack {
                    if let prob = quizVM.ctx.currentProblem {
                        MyMultiChoiceView(
                            problem: prob,
                            quiz: quizVM.quiz!,
                            isReviewMode: false)
                    }
                }.padding()
                
                Spacer()
                
                nextButtonView
                
                Spacer()
            }
            .navigationDestination(isPresented: Binding(
                get: { quizVM.showResults },
                set: { quizVM.showResults = $0 }
            )) {
                ResultView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden()
        .environmentObject(quizVM)
        .onAppear {
            quizVM.quiz = session.quiz!
        }
    }
    
    var nextButtonView: some View {
        NavigationLink(value: quizVM.quiz) {
            StandardButton(title: "Next", action: {
                quizVM.handleNextButtonClick()
            })
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
            .environment(User(username: "adipai", pin: "1111", name: "Adi"))
            .environmentObject(Theme.theme1) // Use your default theme here
            .environmentObject(Session())
            .environmentObject(NavigationManager())
    }
}
