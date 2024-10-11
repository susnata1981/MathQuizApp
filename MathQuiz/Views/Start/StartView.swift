import SwiftUI

struct StartView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var session: Session
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Spacer()
                
                Text("Math Quiz")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                StandardButton(title: "Start Quiz", action: {
                    navigationManager.navigate(to: .quizSetup)
                })
                
                StandardButton(title: "View History", action: {
                    navigationManager.navigate(to: .history)
                }, style: SecondaryButtonStyle())
                
                Spacer()
                
                if userManager.isUserLoggedIn {
                    StandardButton(title: "Log Out", action: {
                        userManager.signOut()
                    }, style: SecondaryButtonStyle())
                }
            }
            .padding()
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .quizSetup:
                    QuizSetupView()
                case .quiz:
                    QuizView()
                case .history:
                    HistoryView()
                }
            }
        }
    }
}