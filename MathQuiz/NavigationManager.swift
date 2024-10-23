//
//  NavigationManager.swift
//  MathQuiz
//
//  Created by Susnata Basak on 10/4/24.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectTab: Int = 0
   
    func gotoQuiz() {
        selectTab = 0
        path = NavigationPath()
        path.append(Destination.startQuiz)
    }
   
    func gotoHome() {
        path = NavigationPath()
        selectTab = 0
    }
    
    func gotoProfile() {
        path = NavigationPath()
        selectTab = 0
    }
    
    func gotoQuizFromHistory() {
        selectTab = 0
        path = NavigationPath()
        path.append(Destination.quizSetup)
    }
    
    func gotoCompleteReview() {
        path.append(Destination.complete)
    }
}

enum Destination: Hashable {
    case reviewResult(quiz: Quiz)
    case quizSetup
    case startQuiz
    case complete
}
