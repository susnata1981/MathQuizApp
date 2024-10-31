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
    @EnvironmentObject var theme: Theme
    
    @State private var startNewGame = false
    @State private var reviewResult = false
    @State private var showAnimation = true
    @State var score: Int = 0
    
    var body: some View {
        ZStack {
            theme.colors.background.ignoresSafeArea(.all)
            
            VStack(spacing: 30) {
//                resultHeader
                scoreCard
                detailedResults
                actionButtons
            }
            .padding()
            
            if showAnimation {
                if score >= 80 {
                    ConfettiView()
                } else {
                    PulseAnimation()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear{
            score = session.quiz?.score?.percentScore ?? 0
        }
    }
    
    // ... (ConfettiView and PulseAnimation remain the same)
    private var resultHeader: some View {
        Text("Results")
            .font(theme.fonts.large)
            .foregroundColor(theme.colors.primary)
            .padding(.top, 50)
    }
    
    private var scoreCard: some View {
        VStack(spacing: 20) {
            VStack {
                Text("You scored")
                    .foregroundStyle(theme.colors.text)
                    .font(.subheadline)
                
                Text("\(score)%")
                    .font(theme.fonts.xxlarge)
                    .foregroundColor(score > 70 ? theme.colors.primary : theme.colors.text)
                    .fontWeight(.bold)
            }
        }.padding()
    }
    
    private var detailedResults: some View {
        VStack(alignment: .leading, spacing: 10) {
            resultRow(label: "Total Questions", value: "\(session.quiz?.totalProblems ?? 0)")
            resultRow(label: "Correct Answers", value: "\(session.quiz?.score?.totalCorrect ?? 0)")
            resultRow(label: "Incorrect Answers", value: "\(session.quiz?.score?.totalIncorrect ?? 0)")
//            resultRow(label: "Final Score", value: "\(score)%")
        }
        .padding()
        .cornerRadius(10)
    }
    
    private func resultRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(theme.fonts.regular)
                .foregroundColor(theme.colors.text)
            Spacer()
            Text(value)
                .font(theme.fonts.bold)
                .foregroundColor(theme.colors.text)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 15) {
            StandardButton(title: "Start New Game", action: { navigationManager.gotoHome() })
            
//            StandardButton(title: "Review Results", action: { navigationManager.gotoReviewResults(session.quiz!) }, style: SecondaryButtonStyle())
            
            Button(action: { navigationManager.gotoReviewResults(session.quiz!) }) {
                Text("Review Quiz")
                    .font(theme.fonts.regular)
                    .fontWeight(.bold)
                    .foregroundColor(theme.colors.accent)
            }
        }
        .padding(.bottom, 50)
    }
}

struct PulseAnimation: View {
    @State private var animate = false
    
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 200, height: 200)
            .scaleEffect(animate ? 1.2 : 0.8)
            .opacity(animate ? 0 : 1)
            .animation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: false),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}

struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { _ in
                Circle()
                    .fill(Color.random)
                    .frame(width: 15, height: 15)
                    .position(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                              y: animate ? UIScreen.main.bounds.height + 100 : -100)
                    .animation(
                        Animation.linear(duration: Double.random(in: 2...5))
                            .repeatForever(autoreverses: false),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultView()
                .environmentObject(mockQuizViewModel(score: (8, 2))) // 80% score
                .environmentObject(mockSession(score: (8, 2)))
                .environmentObject(NavigationManager())
                .environmentObject(Theme.theme5)
                .previewDisplayName("High Score (Theme 1)")
            
            ResultView()
                .environmentObject(mockQuizViewModel(score: (6, 4))) // 60% score
                .environmentObject(mockSession(score: (6, 4)))
                .environmentObject(NavigationManager())
                .environmentObject(Theme.theme4)
                .previewDisplayName("Low Score (Theme 2)")
            
            ResultView()
                .environmentObject(mockQuizViewModel(score: (10, 0))) // 100% score
                .environmentObject(mockSession(score: (10, 0)))
                .environmentObject(NavigationManager())
                .environmentObject(Theme.theme1)
                .previewDisplayName("Perfect Score")
                .environment(\.colorScheme, .dark)
        }
    }
    
    static func mockQuizViewModel(score: (Int, Int)) -> QuizViewModel {
        let vm = QuizViewModel()
        // Set up any necessary properties in QuizViewModel
        return vm
    }
    
    static func mockSession(score: (Int, Int)) -> Session {
        let session = Session()
        let quiz = Quiz(operation: .add, difficultyLevel: .easy, totalProblems: score.0 + score.1)
        quiz.score = Score(totalCorrect: score.0, totalIncorrect: score.1)
        session.quiz = quiz
        return session
    }
}
