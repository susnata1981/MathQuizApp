//
//  Welcome.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/15/24.
//

import SwiftUI

struct Welcome: View {
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        let _ = print(navigationManager.path)
        Text("Hello, World! \(navigationManager.path.count)")
        
        Button(action: {
            navigationManager.gotoHome()
        }) {
            Text("Home")
                .font(.title2)
        }
    }
}

#Preview {
    Welcome()
}
