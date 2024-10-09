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
    
    // TODO: move this function
    var score: (totalCorrect: Int, totalIncorrect: Int) {
        get {
            var totalCorrect = 0, totalIncorrect = 0
            
            guard quiz != nil else {
                print("Quiz is nil!")
                return (totalCorrect: 0, totalIncorrect: 0)
            }
            
            for (problemId, answer) in quiz!.answers {
                guard let problem = quiz!.getProblemById(problemId: problemId) else {
                    print("Can't find problem with id \(problemId)")
                    return (totalCorrect: 0, totalIncorrect: 0)
                }
                
                if (problem.isAnswerCorrect(userInput: answer)) {
                    totalCorrect = totalCorrect + 1
                } else {
                    totalIncorrect = totalIncorrect + 1
                }
            }
            
            return (totalCorrect, totalIncorrect)
        }
    }
    
    func saveScore() async {
        let currScore = score
        quiz!.score = Score(totalCorrect: currScore.totalCorrect, totalIncorrect: currScore.totalIncorrect)
        quiz?.status = .completed
        
        Task {
            await QuizDao.shared.update(quiz!)
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
