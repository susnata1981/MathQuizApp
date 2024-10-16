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
    
    let selectedTextColor = Color.purple
    let defaultTextColor = Color.white
    
    let selectedChoiceBackgroundColor = Color.purple.opacity(0.4)
    
    @Published var showResults: Bool = false
    @Published var isSelectedChoiceCorrect: Bool = false
    
    @Published var ctx: Context = Context()
    var quiz: Quiz? {
        didSet {
            self.ctx = Context()
            self.ctx.currentProblem = quiz!.getProblem(index: 0)
        }
    }
    
    var session: Session? {
        didSet {
            self.quiz = session!.quiz
            self.ctx = Context()
            self.ctx.currentProblem = quiz!.getProblem(index: ctx.currentIndex)
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
        ctx.selectedChoice = choice
        ctx.hasUserAnswered = true
        isSelectedChoiceCorrect = isSelectionCorrect(choice)
    }
    
    func isSelectionCorrect(_ choice: MultiChoiceItem) -> Bool {
        return ctx.currentProblem!.isAnswerCorrect(
            userInput: choice.content)
    }
    
    func didUserSelect(_ problem: Problem, _ choice: MultiChoiceItem) -> Bool {
        if let q = quiz {
            let answer = q.answers.filter{ $0.key == problem.id }.first?.value
            if answer != nil && choice.content == answer! {
                return true
            }
        }
        
        return false
    }
    
    func getCorrectAnswer() -> String {
        return String(ctx.currentProblem!.answer)
    }
    
    func isChoiceSelected(_ choice: MultiChoiceItem) -> Bool {
        if ctx.selectedChoice != nil {
            // TODO: Change to id
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
        
        quiz!.answers[ctx.currentProblem!.id!] = ctx.selectedChoice!.content
        quiz!.status = .inProgress
        
        Task {
            await QuizDao.shared.update(quiz!)
        }
        
        if hasFinishedQuiz() {
            // Finished Quiz, Update it
            Task {
                if let q = quiz {
                    q.status = .completed
                    q.computeScore()
                    await q.update()
                }
            }
            showResults = true
        } else {
            // Next Question
            getNextProblem()
        }
    }
    
    
    func setAnswer(problem: Problem, answer: Answer) -> Void {
        quiz!.answers[problem.id!] = answer.value
        quiz!.status = .inProgress
        
        Task {
            await QuizDao.shared.update(quiz!)
        }
    }
    
    private func getNextProblem() {
        ctx.currentIndex = ctx.currentIndex + 1
        
        guard ctx.currentIndex < quiz!.problems.count else {
            print("Invalid problem index \(ctx.currentIndex)")
            return
        }
        
        ctx.currentProblem = quiz!.getProblem(index: ctx.currentIndex)
        ctx.selectedAnswer = nil
        ctx.selectedChoice = nil
        ctx.hasUserAnswered = false
    }
    
}
