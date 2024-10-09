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
                        "CorrectResponseCount": totalCorrect,
                        "IncorrectResponseCount": totalIncorrect
                    ])
            } catch {
                print("Error updating final score")
            }
        }
    }
}
