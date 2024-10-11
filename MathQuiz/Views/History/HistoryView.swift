import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            Text("Quiz History")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
//            List(userManager.quizHistory) { quiz in
//                VStack(alignment: .leading) {
//                    Text("Date: \(quiz.date, formatter: dateFormatter)")
//                    Text("Score: \(quiz.score)/\(quiz.totalQuestions)")
//                    Text("Difficulty: \(quiz.difficulty.rawValue.capitalized)")
//                    Text("Operation: \(quiz.operation.rawValue.capitalized)")
//                }
//            }
//            
//            StandardButton(title: "Back to Start", action: {
//                navigationManager.navigateToRoot()
//            }, style: SecondaryButtonStyle())
//            .padding()
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
