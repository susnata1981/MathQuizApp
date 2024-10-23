//
//  QuizDao.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import Foundation

import FirebaseFirestore

enum AppError: Error {
    case UserNotLoggedIn
    case FirebaseError
}

class QuizDao {
    static let shared = QuizDao()
    
    private init() {}
    
    func getAll(_ user:User) async throws -> [Quiz] {
        
        let task = Task {
            var result = [Quiz]()

            do {
                let db = Firestore.firestore()
                let quizSnapshot = try await db.collection("Quizzes").whereField("uid", isEqualTo: user.username)
                    .order(by: "createdAt", descending: true)
                    .getDocuments()
                
                print("Retrieved quizSnaphot \(quizSnapshot)")
                print(quizSnapshot.documents.count)
                
                for docRef in quizSnapshot.documents {
                    let quiz = try docRef.data(as: Quiz.self)
                    result.append(quiz)
                    print("Quiz = \(quiz)")
                }
                
                return result
            } catch {
                print("Failed to save quiz to firestore \(error)")
                throw AppError.FirebaseError
            }
        }
        
        return try await task.result.get()
    }
    
    func save(_ user:User, _ quiz: Quiz) async throws -> String? {
//        guard let uid = user.username else {
//            print("User uid not set")
//            throw AppError.UserNotLoggedIn
//        }
        
        let task = Task {
            do {
                let db = Firestore.firestore()
                let newQuizRef = try db.collection("Quizzes").addDocument(from: quiz)
                
                print("Saved new quiz: \(newQuizRef.documentID) for user: \(user)")
                return newQuizRef.documentID
            } catch {
                print("Failed to save quiz to firestore \(error)")
                throw AppError.FirebaseError
            }
        }
        
        return try await task.result.get()
    }
    
    func update(_ quiz: Quiz) async {
        let db = Firestore.firestore()
        
        Task {
            do {
                try db.collection("Quizzes").document(quiz.id!).setData(from: quiz)
            } catch {
                print("Error updating answers inside quiz \(String(describing: quiz.id)): \(error.localizedDescription)")
            }
        }
    }
}
