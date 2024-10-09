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
    
    @State var shake = false
    
    struct Constants {
        static let totalProblems = 3
        static let multiChoiceCount = 4
    }
    
    var body: some View {
        
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.2), .pink.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
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
        .environmentObject(quizVM)
        .onAppear {
            quizVM.quiz = session.quiz!
        }
    }
    
    var nextButtonView: some View {
        NavigationLink(value: quizVM.quiz) {
            Button(action: {
                quizVM.handleNextButtonClick()
            }) {
                Text("Next")
                    .font(.custom("Comic Sans MS", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(25)
                    .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 3)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    QuizView()
        .environment(User(uid: "AABSBS", name: "Adi", email: "adi@gmail.com"))
//        .environment(QuizViewModel())
}
