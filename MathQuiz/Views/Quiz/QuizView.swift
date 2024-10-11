////
////  ContentView.swift
////  MathQuiz
////
////  Created by Susnata Basak on 8/30/24.
////
//

//import SwiftUI
//
//struct QuizView: View {
//    
//    @StateObject var quizVM = QuizViewModel()
//    @EnvironmentObject var session: Session
//    @EnvironmentObject var navigationManager: NavigationManager
//    
//    @State var shake = false
//    
//    struct Constants {
//        static let totalProblems = 3
//        static let multiChoiceCount = 4
//    }
//    
//    var body: some View {
//        
//        ZStack {
//            // Background
//            LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.2), .pink.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                Spacer()
//                
//                ProblemSectionView(
//                    indexOfProblem: quizVM.ctx.currentIndex, 
//                    problem: quizVM.currentProblem, 
//                    quiz: quizVM.quiz)
//                
//                HStack {
//                    if let prob = quizVM.ctx.currentProblem {
//                        MyMultiChoiceView(
//                            problem: prob, 
//                            quiz: quizVM.quiz!,
//                            isReviewMode: false)
//                    }
//                }.padding()
//                
//                nextButtonView
//                
//                Spacer()
//            }
//            .navigationDestination(isPresented: Binding(
//                get: { quizVM.showResults },
//                set: { quizVM.showResults = $0 }
//            )) {
//                ResultView()
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .navigationBarBackButtonHidden()
//        .environmentObject(quizVM)
//        .onAppear {
//            quizVM.quiz = session.quiz!
//        }
//    }
//    
//    var nextButtonView: some View {
//        NavigationLink(value: quizVM.quiz) {
//            StandardButton(title: "Next", action: {
//                quizVM.handleNextButtonClick()
//            })
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//
//#Preview {
//    QuizView()
//        .environment(User(uid: "AABSBS", name: "Adi", email: "adi@gmail.com"))
////        .environment(QuizViewModel())
//}

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
            // Background
            theme.colors.background
                .edgesIgnoringSafeArea(.all)
            
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
            .environment(User(uid: "AABSBS", name: "Adi", email: "adi@gmail.com"))
            .environmentObject(Theme.theme1) // Use your default theme here
            .environmentObject(Session())
            .environmentObject(NavigationManager())
    }
}
