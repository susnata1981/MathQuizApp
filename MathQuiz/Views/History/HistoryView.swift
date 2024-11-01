import SwiftUI

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var theme: Theme
    
    var quizzes: [Quiz]
    
    var body: some View {
        ZStack {
            theme.colors.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                headerView
                
                weeklyQuizGraph
                    .padding(.bottom)
                
                VStack {
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(theme.colors.secondary)
                    
                }.padding(.horizontal, 32)
                
                if (quizzes.isEmpty) {
                    Spacer()
                    Text("Start your first quiz to see results here!")
                        .foregroundColor(theme.colors.text)
                    
                    Spacer()
                } else {
                    
                    List {
                        ForEach(quizzes, id: \.id) { quiz in
                            HStack {
                                QuizRowView(quiz: quiz)
                                    .frame(maxWidth: .infinity)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.red)
                            }
                            .contentShape(Rectangle()) // Makes the entire row tappable
                            .onTapGesture {
                                // Navigate to destination manually
                                navigationManager.gotoReviewResults(quiz)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }.scrollContentBackground(.hidden)
                        .background(theme.colors.background)
                }
            }
        }
    }
    
    private var name: String {
        get {
            if let uname = userManager.user {
                return "Welcome \(uname.name)"
            }
            
            return "Guest"
        }
    }
    
    private var username: String {
        get {
            if let uname = userManager.user {
                return "username: \(uname.username)"
            }
            
            return ""
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            Text(name)
                .font(theme.fonts.large)
                .foregroundColor(theme.colors.text)
            
            Text(username)
                .font(theme.fonts.regular)
                .foregroundColor(theme.colors.text)
        }
        .padding(.vertical, 24)
    }
    
    private var weeklyQuizGraph: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Quizzes per Week")
                .font(.subheadline)
                .foregroundColor(theme.colors.text)
                .padding(.bottom, 5)
            
            HStack(alignment: .bottom, spacing: 8) {
                let _ = print(weeklyQuizCounts)
                ForEach(weeklyQuizCounts.indices, id: \.self) { index in
                    VStack {
                        Text("\(weeklyQuizCounts[index].1)")
                            .font(theme.fonts.small)
                            .fontWeight(.bold)
                            .foregroundColor(theme.colors.text)
                        
                        Rectangle()
                            .fill(theme.colors.primary)
                            .frame(width: 30, height: barHeight(for: weeklyQuizCounts[index].1))
                        
                        Text("W\(weeklyQuizCounts[index].0)")
                            .font(theme.fonts.small)
                            .foregroundColor(theme.colors.text)
                    }
                }
            }
            .frame(height: 150)
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
        .shadow(color: theme.colors.primary.opacity(0.2), radius: 5, x: 0, y: 2)
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
        .environmentObject(Theme.theme4)
        .colorScheme(.light)
    }
}
