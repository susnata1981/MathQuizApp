//
//  QuizGenerator.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import Foundation

protocol QuizGenerator {
    func generate(
        for operation: MathOperation,
        difficultyLevel: DifficultyLevel,
        numChoicesPerProblem: Int) -> Problem
}

class SimpleQuizGenerator: QuizGenerator {
    
    private init() {}
    
    static let shared = SimpleQuizGenerator()
    
    func generate(
        for oper: MathOperation,
        difficultyLevel: DifficultyLevel,
        numChoicesPerProblem: Int) -> Problem {
            
        let n1 = Int.random(in: 1...20)
        let n2 = Int.random(in: 1...20)
            
        return Problem(
            num1: n1, num2: n2, operation: oper, numChoices: numChoicesPerProblem)
    }
}
