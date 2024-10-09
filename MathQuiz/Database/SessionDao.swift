//
//  SessionDao.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import Foundation
import FirebaseFirestore

class SessionDao {
    
    static let shared = SessionDao()
    
    private init() { }
    
    func setAnswer(quiz: Quiz) async {
        let db = Firestore.firestore()
        
        Task {
            do {
                try db.collection("Quizzes").document(quiz.id!).setData(from: quiz, merge: true)
            } catch {
                print("Error updating answers inside quiz \(quiz.id): \(error.localizedDescription)")
            }
        }
    }
    
    func saveScore(
        userId uid:String,
        quizId qid: String,
        _ totalCorrect: Int,
        _ totalIncorrect: Int) async {
            
            Task {
                do {
                    let db = Firestore.firestore()
                    
                    let _ = try await db.collection("Users")
                        .document(uid)
                        .collection("Quizzes")
                        .document(qid)
                        .updateData([
                            "TotalCorrect": totalCorrect,
                            "TotalIncorrect": totalIncorrect
                        ])
                } catch {
                    print("Error updating final score \(error.localizedDescription)")
                }
            }
        }
}
