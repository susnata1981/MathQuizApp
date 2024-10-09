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
}

enum DifficultyLevel: String, CaseIterable, Codable {
    case easy = "Easy", medium = "Medium", hard = "Hard"
}

class Quiz: CustomDebugStringConvertible, Hashable, Codable {
    private static let NUM_PROBLEMS = 10
    
    var id: String?
    let difficultyLevel: DifficultyLevel
    let operation: MathOperation
    let totalProblems: Int
    var numChoicesPerProblem = 4
    
    var problems = [Problem]()
    
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
    
    func getProblem(index: Int) -> Problem? {
        guard index < problems.count else {
            print("\(index) exceed problem size")
            return nil
        }
        
        return problems[index]
    }
    
    func getProblemCount() -> Int { problems.count }

    private func save(_ user:User) async {
        do {
            self.id = try await QuizDao.shared.save(user, self)
        } catch {
            print("Failed to save quiz!")
        }
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

