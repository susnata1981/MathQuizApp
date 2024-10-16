//
//  QuizSession.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/31/24.
//

import Foundation

class Session: ObservableObject, Hashable {
    
    @Published var user: User?
    var quiz: Quiz?
    
    init() {}
    
    func setAnswer(problem: Problem, answer: Answer) -> Void {
        quiz!.answers[problem.id!] = answer.value
        quiz!.status = .inProgress
        
        Task {
            await QuizDao.shared.update(quiz!)
        }
    }
    
//    // TODO: move this function
//    var score: Score {
//        return quiz!.computeScore()
//    }
    
    func saveScore() async {
        if let q = quiz {
            q.status = .completed
            
            Task {
                await QuizDao.shared.update(q)
            }
        }
    }
    
    func resetQuiz() {
        quiz = nil
    }
    
    static func == (lhs: Session, rhs: Session) -> Bool {
        lhs.quiz == rhs.quiz && lhs.user == rhs.user
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(quiz)
        hasher.combine(user)
    }
}
