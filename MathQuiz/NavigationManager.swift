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
   
    enum Destination: Hashable {
        case reviewResult(quiz: Quiz)
        case startQuiz
        case complete
    }
    
    func gotoQuiz() {
        path.append(Destination.startQuiz)
    }
   
    func gotoHome() {
        path = NavigationPath()
        selectTab = 0
    }
}
