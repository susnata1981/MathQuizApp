//
//  ProfileViewModel.swift
//  MathQuiz
//
//  Created by Susnata Basak on 10/2/24.
//

import Foundation

@Observable
class ProfileViewModel {
    var user: User?
    var quizzes = [Quiz]()
    
    init(user: User? = nil) {
        self.user = user
    }
    
    func getQuizzes() async {
        guard user != nil else {
            return
        }
        
        let task = Task {
            do {
                return try await QuizDao.shared.getAll(user!)
            } catch {
                print("Failed to load any quiz data for user \(user!), error: \(error.localizedDescription)")
                return []
            }
        }
        
        do {
            let allQuizzes = try await task.result.get()
            self.quizzes.removeAll()
            self.quizzes.append(contentsOf: allQuizzes)
        } catch {
            print("Failed to load any quiz data for user \(user!), error: \(error.localizedDescription)")
            self.quizzes.removeAll()
        }
    }
}
