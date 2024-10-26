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
            theme.colors.background.ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                ProblemSectionView(
                    indexOfProblem: quizVM.ctx.currentIndex,
                    problem: quizVM.currentProblem,
                    quiz: quizVM.quiz)
                .frame(minHeight: 280)
                
                
                ZStack {
                    theme.colors.primary.opacity(0.4).ignoresSafeArea(.all)
                    
                    VStack {
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
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { quizVM.showResults },
                set: { quizVM.showResults = $0 }
            )) {
                ResultView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .environmentObject(quizVM)
        .onAppear {
            quizVM.quiz = session.quiz!
            UITabBar.appearance().isHidden = true
        }
        .onDisappear {
            UITabBar.appearance().isHidden = false
        }
    }
    
    var nextButtonView: some View {
        NavigationLink(value: quizVM.quiz) {
            StandardButton(title: "Next", action: {
                quizVM.handleNextButtonClick()
            }, style: PrimaryButtonStyleDarkMode())
        }

    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with a mock quiz in progress
            QuizView()
                .environmentObject(mockSession())
                .environmentObject(NavigationManager())
                .environmentObject(Theme.theme1)
                .previewDisplayName("Quiz in Progress (Theme 1)")
            
            // Preview with a different theme
            QuizView()
                .environmentObject(mockSession())
                .environmentObject(NavigationManager())
                .environmentObject(Theme.theme2)
                .previewDisplayName("Quiz in Progress (Theme 2)")
            
            // Preview in dark mode
            QuizView()
                .environmentObject(mockSession())
                .environmentObject(NavigationManager())
                .environmentObject(Theme.theme1)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
    
    static func mockSession() -> Session {
        let session = Session()
        session.quiz = Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 5)
        return session
    }
}

