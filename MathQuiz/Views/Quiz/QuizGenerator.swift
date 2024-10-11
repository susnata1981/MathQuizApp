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
        for operation: MathOperation,
        difficultyLevel: DifficultyLevel,
        numChoicesPerProblem: Int) -> Problem {
            
        let (num1, num2) = generateNumbers(for: operation, difficultyLevel: difficultyLevel)
        
        return Problem(
            num1: num1,
            num2: num2,
            operation: operation,
            numChoices: numChoicesPerProblem)
    }
    
    private func generateNumbers(for operation: MathOperation, difficultyLevel: DifficultyLevel) -> (Int, Int) {
        switch operation {
        case .add:
            return generateAdditionNumbers(for: difficultyLevel)
        case .subtract:
            return generateSubtractionNumbers(for: difficultyLevel)
        case .multiply:
            return generateMultiplicationNumbers(for: difficultyLevel)
        case .divide:
            return generateDivisionNumbers(for: difficultyLevel)
        }
    }
    
    private func generateAdditionNumbers(for difficultyLevel: DifficultyLevel) -> (Int, Int) {
        let range: ClosedRange<Int>
        switch difficultyLevel {
        case .easy:
            range = 1...10
        case .medium:
            range = 1...50
        case .hard:
            range = 1...100
        }
        return (Int.random(in: range), Int.random(in: range))
    }
    
    private func generateSubtractionNumbers(for difficultyLevel: DifficultyLevel) -> (Int, Int) {
        let range: ClosedRange<Int>
        switch difficultyLevel {
        case .easy:
            range = 1...10
        case .medium:
            range = 1...50
        case .hard:
            range = 1...100
        }
        let num1 = Int.random(in: range)
        let num2 = Int.random(in: 1...num1)  // Ensure positive result
        return (num1, num2)
    }
    
    private func generateMultiplicationNumbers(for difficultyLevel: DifficultyLevel) -> (Int, Int) {
        let range: ClosedRange<Int>
        switch difficultyLevel {
        case .easy:
            range = 1...10
        case .medium:
            range = 1...12
        case .hard:
            range = 2...15
        }
        return (Int.random(in: range), Int.random(in: range))
    }
    
    private func generateDivisionNumbers(for difficultyLevel: DifficultyLevel) -> (Int, Int) {
        let range: ClosedRange<Int>
        switch difficultyLevel {
        case .easy:
            range = 1...10
        case .medium:
            range = 1...12
        case .hard:
            range = 2...15
        }
        let divisor = Int.random(in: range)
        let quotient = Int.random(in: range)
        let dividend = divisor * quotient
        return (dividend, divisor)
    }
}
