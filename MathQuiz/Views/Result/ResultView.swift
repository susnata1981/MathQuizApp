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
    @State private var score: Int = 0
    
    
    var body: some View {
        ZStack {
            theme.colors.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                resultHeader
                scoreCard
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
        .navigationDestination(isPresented: $startNewGame) {
            StartQuizView()
        }
        .navigationDestination(isPresented: $reviewResult) {
            ReviewResultView(quiz: session.quiz!)
        }
        .onAppear{
            score = session.quiz?.score?.percentScore ?? 0
        }
//        .onAppear {
//            session.quiz!.computeScore()
//            score = session.quiz!.score?.percentScore ?? 0
//            Task { await session.saveScore() }
//        }
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

    private var resultHeader: some View {
        Text("Quiz Results")
            .font(theme.fonts.large)
            .foregroundColor(theme.colors.primary)
            .padding(.top, 50)
    }
    
    private var scoreCard: some View {
        VStack(spacing: 20) {
            HStack {
                Text("You scored")
                    .font(theme.fonts.bold)
                
                Text("\(score)%")
                    .font(theme.fonts.xlarge)
                    .foregroundColor(score > 70 ? theme.colors.success : theme.colors.error)
                    .fontWeight(.bold)
            }
        }.padding()
    }
    
    private var actionButtons: some View {
        VStack(spacing: 15) {
            StandardButton(title: "Start New Game", action: { startNewGame = true })
            
            StandardButton(title: "Review Results", action: { reviewResult = true }, style: SecondaryButtonStyle())
        }
        .padding(.bottom, 50)
    }
}

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ResultView()
//                .environmentObject(mockQuizViewModel(score: (8, 2))) // 80% score
//                .environmentObject(mockSession(score: (8, 2)))
//                .environmentObject(NavigationManager())
//                .environmentObject(Theme.theme1)
//                .previewDisplayName("High Score (Theme 1)")
//            
//            ResultView()
//                .environmentObject(mockQuizViewModel(score: (6, 4))) // 60% score
//                .environmentObject(mockSession(score: (6, 4)))
//                .environmentObject(NavigationManager())
//                .environmentObject(Theme.theme2)
//                .previewDisplayName("Low Score (Theme 2)")
//            
//            ResultView()
//                .environmentObject(mockQuizViewModel(score: (10, 0))) // 100% score
//                .environmentObject(mockSession(score: (10, 0)))
//                .environmentObject(NavigationManager())
//                .environmentObject(Theme.theme1)
//                .previewDisplayName("Perfect Score")
//                .environment(\.colorScheme, .dark)
//        }
//    }
//    
//    static func mockQuizViewModel(score: (Int, Int)) -> QuizViewModel {
//        let vm = QuizViewModel()
//        // Set up any necessary properties in QuizViewModel
//        return vm
//    }
//    
//    static func mockSession(score: (Int, Int)) -> Session {
//        let session = Session()
//        session.score = score
//        session.quiz = Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 5)
//        return session
//    }
//}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
