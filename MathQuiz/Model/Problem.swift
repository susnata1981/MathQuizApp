//
//  Problem.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/2/24.
//

import Foundation
import FirebaseFirestore

struct Problem: CustomDebugStringConvertible, Hashable, Codable {
   
    var id: Int?
    let num1: Int
    let num2: Int
    let operation: MathOperation
    let numChoices: Int
    var multiChoiceItems: [MultiChoiceItem] = []
    var userInput: Answer?
    
    init(num1: Int, num2: Int, operation: MathOperation, numChoices: Int) {
        self.num1 = num1
        self.num2 = num2
        self.operation = operation
        self.numChoices = numChoices
        let _ = initMultiChoiceItems()
    }
    
    var answer: Int {
        get {
            switch (operation) {
            case .add:
                return num1 + num2
            case .subtract:
                return num1 - num2
            case .multiply:
                return num1 * num2
            case .divide:
                return num1 / num2
            }
        }
    }
    
    func getFirstNumber() -> String { String(num1) }
    func getSecondNumber() -> String { String(num2) }
    func getOperationName() -> String { operation.rawValue }
    
    private func getMultipleChoicesForAnswer(_ answer: Int) -> Int {
        return Int.random(in: answer-5...answer+10)
    }
    
    mutating func initMultiChoiceItems() -> [MultiChoiceItem] {
        if !multiChoiceItems.isEmpty {
            return multiChoiceItems
        }
        
        let answer = self.answer
        var result = [answer]
        
        for _ in 0..<numChoices - 1 {
            var temp = getMultipleChoicesForAnswer(answer)
            while (result.contains(temp)) {
                temp = getMultipleChoicesForAnswer(answer)
            }
            result.append(temp)
        }
        
        result.shuffle()
        
        multiChoiceItems.append(contentsOf: result.enumerated().map({(index, elem) in MultiChoiceItem(id: index, content: String(elem)) }))
        
        return multiChoiceItems
    }
    
    func isAnswerCorrect(userInput input: String) -> Bool {
        return Int(input) == answer
    }
    
    var debugDescription: String {
        "Queston: \(num1) \(operation.rawValue) \(num2) = \(answer)"
    }
    
    static func == (lhs: Problem, rhs: Problem) -> Bool {
        lhs.id == rhs.id && lhs.num1 == rhs.num1 && lhs.num2 == rhs.num2 && lhs.operation == rhs.operation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(num1)
        hasher.combine(num2)
        hasher.combine(operation)
    }
}

struct MultiChoiceItem: Hashable, Identifiable, Codable {
    var id: Int
    let content: String
    
    init(id: Int, content: String) {
        self.id = id
        self.content = content
    }
    
    var isSelected = false {
        willSet {
            print("[MultiChoiceItem: \(content)] New value set to \(newValue)")
        }
        
        didSet {
            print("[MultiChoiceItem: \(content)] Old value set to \(oldValue):\(isSelected)")
        }
    }
        
    mutating func setSelected() {
        isSelected = true
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
    }
}

struct Answer: Codable {
    let value: String
}
