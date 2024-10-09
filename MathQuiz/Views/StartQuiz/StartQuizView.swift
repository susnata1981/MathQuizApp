////
////  StartQuiz.swift
////  MathQuiz
////
////  Created by Susnata Basak on 8/31/24.
////
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct StartQuizView: View {
    
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var session: Session
    
    @State var sqViewModel = StartQuizViewModel()
    @State private var showCountdown = false
    @State private var gameStarted = false
    
    @StateObject var navManager = NavigationManager()
    @StateObject var navigationManager2 = NavigationManager()
    
    var body: some View {
        TabView {
            NavigationStack(path: $navManager.path) {
                VStack {
                    SelectGameView(sqViewModel: sqViewModel, showCountdown: $showCountdown)
                }.navigationDestination(for: Destination.self) { dest in
                    let _ = print("SQV: destination = \(dest)")
                    switch(dest) {
                    case .startQuiz:
                        QuizView()
                    case .complete:
                        CompletedReviewView()
                    case .reviewResult(let quiz):
                        ReviewResultView(quiz: quiz)
                    }
                }
            }
            .environmentObject(navManager)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            
            // Second Tab
            NavigationStack(path: $navigationManager2.path) {
                VStack {
                    ProfileView()
                        .environmentObject(navigationManager2)
                }.navigationDestination(for: Destination.self) { value in
                    switch value {
                    case .reviewResult(let quiz):
                        ReviewResultView(quiz: quiz)
                    case .complete:
                        CompletedReviewView()
                    case .startQuiz:
                        QuizView()
                    }
                }
            }.environmentObject(navigationManager2)
                .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }
            .tag(1)
            
        }.onAppear {
            session.user = userManager.user
            sqViewModel.user = userManager.user
        }
        
    }
}

struct SelectGameView: View {
    var sqViewModel: StartQuizViewModel
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var session: Session
    @Binding var showCountdown:Bool
    @EnvironmentObject var navManager: NavigationManager

    var body: some View {
        VStack {
            ZStack {
                if showCountdown {
                    MyCountDownView(showCountdown: $showCountdown) {
                        Task {
                            session.quiz = await sqViewModel.handleStartQuiz()
                            showCountdown = false
                            navManager.gotoQuiz()
                        }
                    }
                    .transition(.opacity)
                }
                
                VStack(spacing: 30) {
                    Text("Math Quiz")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                                .blur(radius: 10)
                        )
                    
                    Text("Choose Game")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("primary"))
                    
                    ChooseGameType(viewModel: sqViewModel)
                    
                    DifficultyPicker(viewModel: sqViewModel)
                    
                    Button(action: {
                        if (sqViewModel.validate()) {
                            showCountdown = true
                        }
                    }) {
                        Text("Start Quiz")
                            .modifier(ImprovedDefaultTextButton())
                    }
                    .alert("Choose operation", isPresented: Binding<Bool> (
                        get: { sqViewModel.hasError },
                        set: { sqViewModel.hasError = $0 }
                    )) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Please select an operation before starting the quiz.")
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        userManager.signOut { error in
                            print("Error = \(String(describing: error))")
                        }
                    }) {
                        Text("\(userManager.user!.name) Sign Out")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(8)
                    }
                    .opacity(userManager.isUserLoggedIn() ? 1 : 0)
                }
            }
        }
    }
}

struct ChooseGameType: View {
    let viewModel: StartQuizViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
            ForEach(MathOperation.allCases, id: \.self) { operation in
                GameTypeButton(operation: operation, viewModel: viewModel)
            }
        }
        .padding()
    }
}

struct GameTypeButton: View {
    let operation: MathOperation
    let viewModel: StartQuizViewModel
    
    var body: some View {
        Button(action: { viewModel.handleSelectOperation(operation) }) {
            VStack {
                Text(operation.rawValue)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)

                Text(operation.description)
                    .font(.caption)
                    .foregroundColor(.white)

            }
            .frame(width: 100, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(viewModel.selectedOperation == operation ? Color.green.opacity(0.8) : Color("primary"))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
            )
        }
        .animation(.spring(), value: viewModel.selectedOperation)
    }
}

struct DifficultyPicker: View {
    let viewModel: StartQuizViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Difficulty Level")
                .font(.headline)
                .foregroundColor(.white)
            
            Picker("Select Difficulty", selection: Binding(
                get: { viewModel.selectedDiffilcultyLevel },
                set: { viewModel.selectedDiffilcultyLevel = $0 }
            )) {
                ForEach(DifficultyLevel.allCases, id: \.self) { level in
                    Text(level.rawValue.capitalized)
                        .tag(level)
                }
            }
            .pickerStyle(.segmented)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
        .padding()
    }
}

struct ImprovedDefaultTextButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding()
            .background(Color("primary"))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

//#Preview {
//    StartQuizView()
//        .environmentObject(QuizViewModel())
//        .environmentObject(UserManager())
//}
