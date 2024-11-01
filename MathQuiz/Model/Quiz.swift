//
//  Quiz.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/31/24.
//

import Foundation
import FirebaseFirestore

enum MathOperation: String, CaseIterable, Codable {
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"

    var symbol: String {
        switch self {
        case .add: return "plus"
        case .subtract: return "minus"
        case .multiply: return "multiply"
        case .divide: return "divide"
        }
    }
    
    var description: String {
        switch self {
        case .add: return "Add"
        case .subtract: return "Subtract"
        case .multiply: return "Multiply"
        case .divide: return "Divide"
        }
    }
}

enum DifficultyLevel: String, CaseIterable, Codable {
    case easy = "Easy", medium = "Medium", hard = "Hard"
}

enum CompletionStatus: String, Codable {
    case notStarted = "Not Started", inProgress = "In Progress", completed = "Completed"
}

class Quiz: CustomDebugStringConvertible, Hashable, Codable {
    private static let NUM_PROBLEMS = 10
    
    var id: String?
    var uid: String?
    let difficultyLevel: DifficultyLevel
    let operation: MathOperation
    let totalProblems: Int
    var numChoicesPerProblem = 4
    var timeInSeconds: TimeInterval?
    
    var problems = [Problem]()
    var answers = [Int:String]()
    var score: Score?
    var status: CompletionStatus = .notStarted
    var points: Int
    var createdAt = Date()
    
    init(operation: MathOperation,
         difficultyLevel: DifficultyLevel,
         totalProblems: Int,
         createdAt: Date = Date()) {
        
        self.operation = operation
        self.difficultyLevel = difficultyLevel
        self.totalProblems = totalProblems
        self.createdAt = createdAt
        self.score = Score(totalCorrect: 0, totalIncorrect: 0)
        self.points = 0

        self.problems = (1...totalProblems).map { index in
            
            var problem = SimpleQuizGenerator.shared.generate(
                for: operation,
                difficultyLevel: difficultyLevel,
                numChoicesPerProblem: numChoicesPerProblem)
            problem.id = index
            return problem
        }
    }
    
    func addPointsForQuiz(correctAnswers: Int, totalQuestions: Int, difficulty: DifficultyLevel) {
            let percentageCorrect = Double(correctAnswers) / Double(totalQuestions)
            let basePoints = Int(Double(totalQuestions) * percentageCorrect * 10)
            
            let difficultyMultiplier: Double
            switch difficulty {
            case .easy:
                difficultyMultiplier = 1.0
            case .medium:
                difficultyMultiplier = 1.5
            case .hard:
                difficultyMultiplier = 2.0
            }
            
            let earnedPoints = Int(Double(basePoints) * difficultyMultiplier)
            self.points += earnedPoints
        }
    
    static func createAndSave(
        user: User,
        operation: MathOperation,
        level: DifficultyLevel,
        numProblems: Int = Quiz.NUM_PROBLEMS) async ->  Quiz {
        
        let q = Quiz(operation: operation, difficultyLevel: level, totalProblems: numProblems)
            print("About to save quiz")
        await q.save(user)
        return q
    }
    
    func computeScore() {
        var totalCorrect = 0, totalIncorrect = 0
        
        
        for (problemId, answer) in answers {
            guard let problem = getProblemById(problemId: problemId) else {
                print("Can't find problem with id \(problemId)")
                self.score = Score(totalCorrect: 0, totalIncorrect: 0)
                return
            }
            
            if (problem.isAnswerCorrect(userInput: answer)) {
                totalCorrect = totalCorrect + 1
            } else {
                totalIncorrect = totalIncorrect + 1
            }
        }
        self.score = Score(totalCorrect: totalCorrect, totalIncorrect: totalIncorrect)
    }
    
    func getProblem(index: Int) -> Problem {
        return problems[index]
    }
    
    func getProblemById(problemId: Int) -> Problem? {
        return problems.filter{ $0.id == problemId }.first
    }
    
    func getProblemCount() -> Int { problems.count }

    private func save(_ user:User) async {
        do {
            self.uid = user.username
            self.id = try await QuizDao.shared.save(user, self)
        } catch {
            print("Failed to save quiz!")
        }
    }
    
    func update() async {
        await QuizDao.shared.update(self)
    }
    
    var getPercentageScore: Int {
        if let score = self.score {
            return score.percentScore
        }
        
        return 0
    }
    
    func getCreatedAtDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self.createdAt)
    }
    
    var debugDescription: String {
        var result:String = ""
        
        problems.forEach({ elem in
            result.append(contentsOf: elem.debugDescription)
            result.append("\n")
        })
        
        return result
    }
    
    static func == (lhs: Quiz, rhs: Quiz) -> Bool {
        return lhs.id == rhs.id
        && lhs.difficultyLevel == rhs.difficultyLevel
        && lhs.operation == rhs.operation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(difficultyLevel)
        hasher.combine(operation)
    }
}

