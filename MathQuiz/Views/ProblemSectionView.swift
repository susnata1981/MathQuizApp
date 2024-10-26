//
//  ProblemSectionView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/2/24.
//

import SwiftUI

struct ProblemSectionView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var theme: Theme
    
    var indexOfProblem: Int
    var problem: Problem?
    var quiz: Quiz?
    
    var body: some View {
        
            if let problem = problem, let q = quiz {
                VStack(spacing: 20) {
                    
                    Text("QUESTION \(indexOfProblem + 1) of \(q.totalProblems)")
                        .font(theme.fonts.regular)
                        .fontWeight(.bold)
                        .foregroundColor(theme.colors.primary.opacity(0.8))
                    
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Text(problem.getFirstNumber())
                        Text(problem.getOperationName())
                        Text(problem.getSecondNumber())
                    }
                    .font(theme.fonts.xxlarge.weight(.bold))
                    .foregroundColor(theme.colors.primary)
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .cornerRadius(8)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
            }
        }
}

struct ProblemSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemSectionView(
            indexOfProblem: 0,
            problem: Problem(num1: 2, num2: 3, operation: .add, numChoices: 4),
            quiz: nil
        )
        .environmentObject(UserManager())
        .environmentObject(Theme.theme1) // Use your default theme here
        
        
        ProblemSectionView(
            indexOfProblem: 0,
            problem: Problem(num1: 2, num2: 3, operation: .add, numChoices: 4),
            quiz: nil
        )
        .environmentObject(UserManager())
        .environmentObject(Theme.theme1) // Use your default theme here
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
