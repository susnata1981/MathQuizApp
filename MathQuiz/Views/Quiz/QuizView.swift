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
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            theme.colors.background.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    timerView
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                progressBar
                    .padding(.top, 8)
                
                   ProblemSectionView(
                        indexOfProblem: quizVM.ctx.currentIndex,
                        problem: quizVM.currentProblem,
                        quiz: quizVM.quiz)
                    .frame(minHeight: 240)
                
//
//                VStack {
//                    Divider()
//                        .frame(minHeight: 1)
//                        .overlay(theme.colors.primary)
//                        
//                }.padding(.horizontal, 16)
                
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
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        
    }
    
    var timerView: some View {
        Text(timeString(from: elapsedTime))
            .font(theme.fonts.regular)
            .foregroundColor(theme.colors.text)
            .padding(8)
            .cornerRadius(8)
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
            
            Text("\(quizVM.ctx.currentIndex + 1) of \(quizVM.quiz?.totalProblems ?? 0)")
                .font(theme.fonts.caption)
                .foregroundColor(theme.colors.primary)
        }
        .padding(.horizontal)
    }
    
    func progressWidth(for totalWidth: CGFloat) -> CGFloat {
        let progress = CGFloat(quizVM.ctx.currentIndex + 1) / CGFloat(quizVM.quiz?.totalProblems ?? 1)
        return totalWidth * progress
    }
    
    var nextButtonView: some View {
           NavigationLink(value: quizVM.quiz) {
               StandardButton(title: "Next", action: {
                   if quizVM.hasFinishedQuiz() {
                       stopTimer()
                       quizVM.elapsedTime = elapsedTime  // Add this line
                   }
                   
                   quizVM.handleNextButtonClick()
//                   if quizVM.showResults {
//                       quizVM.elapsedTime = elapsedTime  // Add this line
//                   }
               })
           }
       }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with a mock quiz in progress
            QuizView()
                .environmentObject(mockSession())
                .environmentObject(NavigationManager())
                .environmentObject(Theme.theme4)
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

