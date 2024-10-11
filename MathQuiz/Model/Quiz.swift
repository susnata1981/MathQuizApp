//
//  Quiz.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/31/24.
//

import Foundation
import FirebaseFirestore

enum MathOperation: String, CaseIterable, Codable {
    case add = "+", subtract = "-", multiply = "x", divide = "%"
    
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
    
    var problems = [Problem]()
    var answers = [Int:String]()
    var score: Score?
    var status: CompletionStatus = .notStarted
    var createdAt = Date()
    
    init(operation: MathOperation,
         difficultyLevel: DifficultyLevel,
         totalProblems: Int) {
        self.operation = operation
        self.difficultyLevel = difficultyLevel
        self.totalProblems = totalProblems
        self.problems = (1...totalProblems).map { index in
            
            var problem = SimpleQuizGenerator.shared.generate(
                for: operation,
                difficultyLevel: difficultyLevel,
                numChoicesPerProblem: numChoicesPerProblem)
            problem.id = index
            return problem
        }
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
    
    func getProblem(index: Int) -> Problem {
        return problems[index]
    }
    
    func getProblemById(problemId: Int) -> Problem? {
        return problems.filter{ $0.id == problemId }.first
    }
    
    func getProblemCount() -> Int { problems.count }

    private func save(_ user:User) async {
        do {
            self.uid = user.uid
            self.id = try await QuizDao.shared.save(user, self)
        } catch {
            print("Failed to save quiz!")
        }
    }
    
//    var description: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = .medium
//        let formattedDate = dateFormatter.string(from: self.createdAt)
//        
//        return "Status: \(self.status) Score: \(self.score.percentScore ?? 0)"
//    }
    
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

