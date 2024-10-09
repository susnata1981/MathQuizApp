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
    
    func save(_ user:User, _ quiz: Quiz) async throws -> String? {
        guard let uid = user.uid else {
            print("User uid not set")
            throw AppError.UserNotLoggedIn
        }
        
        let task = Task {
            do {
                let db = Firestore.firestore()
                let newQuizRef = try db.collection("Quizzes").addDocument(from: quiz)
                
                print("Saved new quiz: \(newQuizRef.documentID) uid: \(uid)")
                return newQuizRef.documentID
            } catch {
                print("Failed to save quiz to firestore \(error)")
                throw AppError.FirebaseError
            }
        }
        
        return try await task.result.get()
    }
    
//    func save(_ user:User, _ quiz: Quiz) async throws -> String? {
//        guard let uid = user.uid else {
//            print("User uid not set")
//            throw AppError.UserNotLoggedIn
//        }
//        
//        let task = Task {
//            do {
//                let db = Firestore.firestore()
//                
//                // Create Quiz
//                let quizRef = try await db.collection("Quizzes").addDocument(data: [
//                    "createdAt": Date(),
//                    "uid": uid
//                ])
//
//                for (index, item) in quiz.problems.enumerated() {
//                    let problemRef = try await db.collection("Quizzes")
//                        .document(quizRef.documentID)
//                        .collection("Problems")
//                        .addDocument(from: item)
//                    
//                    let choicesRef = db.collection("Quizzes")
//                        .document(quizRef.documentID)
//                        .collection("Problems")
//                        .document(problemRef.documentID)
//                        .collection("Choices")
//                    
//                    for var choice in item.multiChoiceItems {
//                        let choiceRef = try choicesRef.addDocument(from: choice)
//                        choice.id = choiceRef.documentID
//                    }
//                }
//                
//                // Save the quiz under Users
//                let _ = try await db.collection("Users")
//                    .document(uid)
//                    .collection("Quizzes")
//                    .document(quizRef.documentID).setData([
//                        "id": quizRef.documentID
//                    ])
//                print("Saved new quiz: \(quizRef.documentID) uid: \(uid)")
//                return quizRef.documentID
//            } catch {
//                print("Failed to save quiz to firestore \(error)")
//                throw AppError.FirebaseError
//            }
//        }
//        
//        return try await task.result.get()
//    }
}
