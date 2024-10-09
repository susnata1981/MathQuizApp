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
    @State var sqViewModel = StartQuizViewModel()
    
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var session: Session
    
    @State private var showCountdown = false
    @State private var gameStarted = false

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    if showCountdown {
                        MyCountDownView(showCountdown: $showCountdown) {
                            Task {
                                await sqViewModel.handleStartQuiz()
                                print("Finished countdown")
                                showCountdown = false
                            }
                        }
                        .transition(.opacity)
                    }
                    
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    
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
                            .foregroundColor(.white)
                        
                        Text(String(sqViewModel.showQuizView))
                            .font(.headline)
                        
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
                        .alert("Choose operation", isPresented: $sqViewModel.hasError) {
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
                }.navigationDestination(isPresented: $sqViewModel.showQuizView) {
                    QuizView()
                }
            }
        }
        .onAppear {
            session.user = userManager.user
            sqViewModel.user = userManager.user
            sqViewModel.session = session
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
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(width: 100, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(viewModel.selectedOperation == operation ? Color.green.opacity(0.8) : Color.blue.opacity(0.6))
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
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

extension MathOperation {
    var description: String {
        switch self {
        case .add: return "Add"
        case .subtract: return "Subtract"
        case .multiply: return "Multiply"
        case .divide: return "Divide"
        }
    }
}

#Preview {
    StartQuizView()
        .environmentObject(QuizViewModel())
        .environmentObject(UserManager())
}
