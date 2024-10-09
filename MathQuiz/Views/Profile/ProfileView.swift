//
//  ProfileView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 10/2/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userManager: UserManager
    @State var profileVM = ProfileViewModel()
    
    @EnvironmentObject var navigationManager: NavigationManager
    
//    enum Destination: Hashable {
//        case reviewResult(quiz: Quiz)
//    }
    
    var body: some View {
        VStack {
            Text("Total quiz: \(profileVM.quizzes.count)")
            
            List(profileVM.quizzes, id: \.id) { quiz in
                
                NavigationLink(value: Destination.reviewResult(quiz: quiz)) {
                    HStack {
                        Text("\(quiz.getCreatedAtDate())")
                            .font(.body)
                        
                        Text("Status: \(quiz.status.rawValue)")
                            .font(.body)
                        
                        Text("Score: \(quiz.getPercentageScore)%")
                            .font(.body)
                    }
                }
            }.navigationDestination(for: Destination.self) { value in
                switch value {
                case .reviewResult(let quiz):
                    ReviewResultView(quiz: quiz)
                }
            }
            .onAppear {
                profileVM.user = userManager.user
                Task {
                    await profileVM.getQuizzes()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
