////
////  StartQuiz.swift
////  MathQuiz
////
////  Created by Susnata Basak on 8/31/24.
////
//


import SwiftUI

struct StartQuizView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var session: Session
    @EnvironmentObject var theme: Theme
    
    @State private var viewModel = StartQuizViewModel()
    @State private var showCountdown = false
    
    @StateObject var quizNavManager = NavigationManager()
    @StateObject var profileNavManager = NavigationManager()
    
    var body: some View {
        TabView(selection: $quizNavManager.selectTab) {
            NavigationStack(path: $quizNavManager.path) {
                mainContent
                    .navigationDestination(for: Destination.self) { dest in
                        switch dest {
                        case .startQuiz:
                            QuizView()
                        case .complete:
                            CompletedReviewView()
                        case .reviewResult(let quiz):
                            ReviewResultView(quiz: quiz)
                        }
                    }
            }
            .environmentObject(quizNavManager)
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack(path: $profileNavManager.path) {
                ProfileView()
                    .navigationDestination(for: Destination.self) { dest in
                        switch dest {
                        case .reviewResult(let quiz):
                            ReviewResultView(quiz: quiz)
                        case .complete:
                            CompletedReviewView()
                        case .startQuiz:
                            QuizView()
                        }
                    }
            }
            .environmentObject(profileNavManager)
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
        }
        .onAppear(perform: setupSession)
        .accentColor(theme.colors.accent)
    }
    
    private var mainContent: some View {
        VStack {
            ZStack {
                theme.colors.background.ignoresSafeArea()
                
                if showCountdown {
                    MyCountDownView(showCountdown: $showCountdown) {
                        Task {
                            print("Animation finished, waiting for quiz handler")
                            session.quiz = await viewModel.handleStartQuiz()
                            showCountdown = false
                            quizNavManager.gotoQuiz()
                        }
                    }
                    .transition(.opacity)
                }
                
                VStack(spacing: 30) {
                    titleView
                    ChooseGameType(viewModel: viewModel)
                    DifficultyPicker(viewModel: viewModel)
                    startButton
                }
                .padding()
            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    signOutButton
//                }
//            }
        }
    }
    
    private var titleView: some View {
        VStack {
            Text("Math Quiz")
                .font(theme.fonts.large)
                .foregroundColor(theme.colors.text)
                .padding()
            
            Text("Choose Game")
                .font(theme.fonts.bold)
                .foregroundColor(theme.colors.primary)
        }
    }
    
    private var startButton: some View {
        StandardButton(title: "Start Quiz", action: {
            if viewModel.validate() {
                showCountdown = true
            }
        })
        .alert("Choose operation", isPresented: $viewModel.hasError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select an operation before starting the quiz.")
        }
    }
    
    private var signOutButton: some View {
        Button(action: {
            userManager.signOut(completion: { err in
                print("Failed to sign out \(String(describing: err?.localizedDescription))")
            })
        }) {
            Text("\(userManager.user?.name ?? "") Sign Out")
                .font(theme.fonts.regular)
                .foregroundColor(theme.colors.text)
                .padding(8)
                .background(theme.colors.accent.opacity(0.8))
                .cornerRadius(8)
        }
        .opacity(userManager.isUserLoggedIn() ? 1 : 0)
    }
    
    private func setupSession() {
        session.user = userManager.user
        viewModel.user = userManager.user
    }
    
    private func startQuiz() {
        Task {
            session.quiz = await viewModel.handleStartQuiz()
            quizNavManager.gotoQuiz()
        }
    }
}

struct ChooseGameType: View {
    @State var viewModel: StartQuizViewModel
    @EnvironmentObject var theme: Theme
    
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
    @State var viewModel: StartQuizViewModel
    @EnvironmentObject var theme: Theme
    
    var body: some View {
        Button(action: { viewModel.handleSelectOperation(operation) }) {
            VStack {
                Text(operation.rawValue)
                    .font(theme.fonts.xlarge)
                Text(operation.description)
                    .font(theme.fonts.regular)
            }
            //            .foregroundColor(theme.colors.text)
            .foregroundColor(.white)
            .frame(width: 100, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(viewModel.selectedOperation == operation ? theme.colors.accent : theme.colors.primary)
                    .shadow(color: theme.colors.primary.opacity(0.3), radius: 5, x: 0, y: 3)
            )
        }
        .animation(.spring(), value: viewModel.selectedOperation)
    }
}

struct DifficultyPicker: View {
    @State var viewModel: StartQuizViewModel
    @EnvironmentObject var theme: Theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Difficulty Level")
                .font(theme.fonts.bold)
                .foregroundColor(theme.colors.text)
            
            Picker("Select Difficulty", selection: $viewModel.selectedDiffilcultyLevel) {
                ForEach(DifficultyLevel.allCases, id: \.self) { level in
                    Text(level.rawValue.capitalized)
                        .tag(level)
                }
            }
            .pickerStyle(.segmented)
            .background(theme.colors.background)
        }
        .padding()
    }
}

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.selectedSegmentTintColor = UIColor(Theme.theme1.colors.accent)
    }
}


