import SwiftUI

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var theme: Theme
    
    var quizzes: [Quiz]
    
    var body: some View {
        VStack {
            headerView
            weeklyQuizGraph
            
            List {
                ForEach(quizzes, id: \.id) { quiz in
                    NavigationLink(value: Destination.reviewResult(quiz: quiz)) {
                        QuizRowView(quiz: quiz)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .background(theme.colors.background)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Text(userManager.user?.name ?? "User")
                .font(theme.fonts.large)
                .foregroundColor(theme.colors.primary)
            
            Text(userManager.user?.email ?? "")
                .font(theme.fonts.regular)
                .foregroundColor(theme.colors.secondary)
        }
        .padding()
    }
    
    private var weeklyQuizGraph: some View {
        VStack(alignment: .leading) {
            Text("Quizzes per Week")
                .font(theme.fonts.bold)
                .foregroundColor(theme.colors.primary)
                .padding(.bottom, 5)
            
            HStack(alignment: .bottom, spacing: 8) {
                let _ = print(weeklyQuizCounts)
                ForEach(weeklyQuizCounts.indices, id: \.self) { index in
                    VStack {
                        Text("\(weeklyQuizCounts[index].1)")
                            .font(theme.fonts.small)
                            .foregroundColor(theme.colors.secondary)
                        
                        Rectangle()
                            .fill(theme.colors.accent)
                            .frame(width: 30, height: barHeight(for: weeklyQuizCounts[index].1))
                        
                        Text("W\(weeklyQuizCounts[index].0)")
                            .font(theme.fonts.small)
                            .foregroundColor(theme.colors.secondary)
                    }
                }
            }
            .frame(height: 150)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
        .background(theme.colors.background)
        .cornerRadius(10)
        .shadow(color: theme.colors.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private func barHeight(for count: Int) -> CGFloat {
        let maxHeight: CGFloat = 100
        
        let maxCount = weeklyQuizCounts.map{ $0.1 }.max() ?? 1
        return CGFloat(count) / CGFloat(maxCount) * maxHeight
    }
    
    private var weeklyQuizCounts: [(Int, Int)] {
        let calendar = Calendar.current
        let now = Date()
        let fourWeeksAgo = calendar.date(byAdding: .weekOfYear, value: -3, to: now)!
        
        var weeklyCounts = [(Int,Int)](repeating: (0,0), count: 4)
        
        for quiz in quizzes {
            if quiz.createdAt >= fourWeeksAgo {
                if let weekIndex = calendar.dateComponents([.weekOfYear], from: quiz.createdAt, to: now).weekOfYear {
                    
                    if weekIndex < 4 {
                        weeklyCounts[3 - weekIndex].0 = calendar.component(.weekOfYear, from: quiz.createdAt)
                        weeklyCounts[3 - weekIndex].1 += 1
                    }
                }
            }
        }
        
        return weeklyCounts
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(quizzes: [
            Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 5),
            Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 5, createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
            Quiz(operation: .add, difficultyLevel: .easy, totalProblems: 5, createdAt: Calendar.current.date(byAdding: .day, value: -10, to: Date())!)
        ])
        .environmentObject(UserManager())
        .environmentObject(NavigationManager())
        .environmentObject(Theme.theme1) // Use your default theme here
    }
}
