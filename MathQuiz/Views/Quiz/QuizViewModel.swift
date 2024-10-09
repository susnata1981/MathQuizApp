//
//  QuizViewModel.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/2/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class QuizViewModel: ObservableObject {
    
    let textColor = Color.purple
    let selectedChoiceBackgroundColor = Color.purple.opacity(0.4)
    
    @Published var showResults: Bool = false
    @Published var isSelectedChoiceCorrect: Bool = false
    
    @Published var ctx: Context = Context()
    var quiz: Quiz?
    
    @Published var currProblem: Problem?
    
    var session: Session? {
        didSet {
            self.quiz = session!.quiz
            self.ctx = Context()
            self.ctx.currentProblem = quiz!.getProblem(index: ctx.currentIndex)!
            self.currProblem = quiz!.getProblem(index: ctx.currentIndex)!
        }
    }
    
    struct Context {
        var currentProblem: Problem?
        var currentIndex: Int = 0
        var selectedAnswer: Int?
        var hasUserAnswered = false
        var selectedChoice: MultiChoiceItem? = nil
    }
    
    var currentProblem: Problem? {
        get {
            ctx.currentProblem
        }
        
        // TODO: This should be private
        set {
            ctx.currentProblem = newValue
        }
    }
    
    func handleChoiceSelection(choice: MultiChoiceItem) {
        guard let _ = self.session else {
            print("Session not set in QuizViewModel")
            return
        }
        
        ctx.selectedChoice = choice
        ctx.hasUserAnswered = true
        isSelectedChoiceCorrect = isSelectionCorrect(choice)
    }
    
    func isSelectionCorrect(_ choice: MultiChoiceItem) -> Bool {
        return ctx.currentProblem!.isAnswerCorrect(
            userInput: choice.content)
    }
    
    func getCorrectAnswer() -> String {
        return String(ctx.currentProblem!.answer)
    }
    
    func isChoiceSelected(_ choice: MultiChoiceItem) -> Bool {
        if ctx.selectedChoice != nil {
            return ctx.selectedChoice!.content == choice.content
        }
        
        return false
    }
    
    func hasUserAnsweredCurrentQuestion() -> Bool {
        return ctx.hasUserAnswered
    }
        
    func hasFinishedQuiz() -> Bool {
        return ctx.currentIndex == quiz!.getProblemCount() - 1
    }
    
    func handleNextButtonClick() -> Void {
        if !hasUserAnsweredCurrentQuestion() {
            return
        }
        
        session!.setAnswer(
            problem: ctx.currentProblem!, answer: Answer(value: ctx.selectedChoice!.content))
        updateChoiceState(ctx.selectedChoice!)
        
        if hasFinishedQuiz() {
            // Finished Quiz
            showResults = true
        } else {
            // Next Question
            getNextProblem()
        }
    }
    
    private func getNextProblem() {
        ctx.currentIndex = ctx.currentIndex + 1
        
        guard ctx.currentIndex < quiz!.problems.count else {
            print("Invalid problem index \(ctx.currentIndex)")
            return
        }
        
        guard let temp = quiz!.getProblem(index: ctx.currentIndex) else {
            print("Error: Failed to fetch problem for index: \(ctx.currentIndex)")
            return
        }
        ctx.currentProblem = temp
        ctx.selectedAnswer = nil
        ctx.selectedChoice = nil
        ctx.hasUserAnswered = false
        currProblem = temp
    }
    
    private func updateChoiceState(_ choice: MultiChoiceItem) {
        let selectedIndex = ctx.currentProblem!.multiChoiceItems.firstIndex(of: choice)
        if selectedIndex != nil {
            ctx.currentProblem!.multiChoiceItems[selectedIndex!].setSelected()
        }
    }
    
}
