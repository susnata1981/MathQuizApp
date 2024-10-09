//
//  Score.swift
//  MathQuiz
//
//  Created by Susnata Basak on 10/1/24.
//

import Foundation

struct Score: Codable {
    let totalCorrect: Int
    let totalIncorrect: Int
    
    var percentScore: Int {
        get {
            if totalCorrect + totalIncorrect != 0 {
                return (100 * totalCorrect)/(totalCorrect + totalIncorrect)
            }
            
            return 0
        }
    }
}
