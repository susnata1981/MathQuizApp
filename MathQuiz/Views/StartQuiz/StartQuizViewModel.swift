//
//  StartQuizViewModel.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/13/24.
//

import Foundation
import SwiftUI

@Observable
class StartQuizViewModel {
    
    let selectedGameTypeButtonColor = Color.orange
    let defaultGameTypeButtonColor = Color.cyan
    
    var quiz: Quiz?
    var user: User?
    
    private static let totalProblems = 3
    var hasError = false
    
    var selectedOperation: MathOperation?
    var selectedDiffilcultyLevel: DifficultyLevel = .easy
    var numberOfProblems: Int = 10

    func validate() -> Bool {
        hasError = false
        
        guard let _ = user else {
            hasError = true
            print("[StartQuizViewModel:: User not set!")
            return false
        }
        
        guard let _ = selectedOperation else {
            hasError = true
            return false
        }
        
        return true
    }
    
    func handleStartQuiz() async -> Quiz? {
        if (!validate()) {
            return nil
        }
        
        quiz = await Quiz.createAndSave(
            user: user!,
            operation: selectedOperation!,
            level: selectedDiffilcultyLevel,
            numProblems: numberOfProblems)
        
        return quiz
    }
    
    func handleSelectOperation(_ op: MathOperation) {
        selectedOperation = op
    }
}
