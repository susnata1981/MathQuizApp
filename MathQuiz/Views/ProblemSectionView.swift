//
//  ProblemSectionView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/2/24.
//

import SwiftUI

struct ProblemSectionView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    var indexOfProblem: Int
    var problem: Problem?
    var quiz: Quiz?
    
    var body: some View {
        if let _ = problem {
            
            let _ = print(quiz ?? "Quiz not available")
            
            VStack {
                Text("Question \(indexOfProblem + 1).")
                    .font(.title3)
                    .foregroundColor(.purple)
                
                HStack(alignment: .firstTextBaseline) {
                    
                    Text(problem!.getFirstNumber())
                    Text(problem!.getOperationName())
                    Text(problem!.getSecondNumber())
                    
                }.font(.system(size: 80))
                    .fontWeight(.bold)
                    .foregroundColor(Color.purple)
            }
        } else {
            ProgressView()
        }
    }
}

//#Preview {
//    @State var vm = QuizViewModel()
//    return ProblemSectionView(viewModel: $vm)
//        .environment(User(name: "Adi", age: 7))
//}
