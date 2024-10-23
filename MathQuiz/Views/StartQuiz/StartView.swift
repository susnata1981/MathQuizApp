//
//  StartView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/12/24.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject var quizNavManager = NavigationManager()
    @StateObject var profileNavManager = NavigationManager()

    var body: some View {
        if (userManager.isUserLoggedIn()) {
            
            TabView {
                NavigationStack(path: $quizNavManager.path) {
                    StartQuizView()
                        .navigationDestination(for: Destination.self) { dest in
                            let _ = print("Navigating to \(dest)")
                                          
                            switch dest {
                            case .quizSetup:
                                StartQuizView()
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
                            case .quizSetup:
                                StartQuizView()
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
        } else {
            SigninView()
        }
    }
}

#Preview {
    StartView().environmentObject(UserManager())
}
