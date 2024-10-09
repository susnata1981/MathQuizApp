//
//  QuizSession.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/31/24.
//

import Foundation

@Observable
class Session: Hashable {
  
    var user: User?
    var quiz: Quiz?
    var problemAnswerMap = [Problem:Answer]()
    
    init(user: User, quiz: Quiz) {
        self.user = user
        self.quiz = quiz
    }
    
    init(quiz: Quiz) {
        self.quiz = quiz
    }
    
    init() {}
    
    func setAnswer(problem: Problem, answer: Answer) -> Void {
        problemAnswerMap[problem] = answer
    }
    
    var score: (Int, Int) {
        get {
            var totalCorrect = 0, totalIncorrect = 0
            
            for (problem, answer) in problemAnswerMap {
                if (problem.isAnswerCorrect(userInput: answer.value)) {
                    totalCorrect = totalCorrect + 1
                } else {
                    totalIncorrect = totalIncorrect + 1
                }
            }
            
            return (totalCorrect, totalIncorrect)
        }
    }
    
   
    static func == (lhs: Session, rhs: Session) -> Bool {
        lhs.quiz == rhs.quiz && lhs.user == rhs.user
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(quiz)
        hasher.combine(user)
    }
}
