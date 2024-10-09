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
    var session: Session?
    
    
    private static let TOTAL_PROBLEMS = 3
    
    var hasError = false
    var showQuizView = false
    
    var selectedOperation: MathOperation?
    var selectedDiffilcultyLevel: DifficultyLevel = .easy
    
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
    
    func handleStartQuiz() async {
        if (!validate()) {
            return
        }
        
        quiz = await Quiz.createAndSave(
            user: user!,
            operation: selectedOperation!,
            level: selectedDiffilcultyLevel,
            numProblems: StartQuizViewModel.TOTAL_PROBLEMS)
        
        // We have already validated that user exists
        session!.quiz = quiz!
        
        showQuizView = true
    }
    
    func handleSelectOperation(_ op: MathOperation) {
        selectedOperation = op
    }
}
