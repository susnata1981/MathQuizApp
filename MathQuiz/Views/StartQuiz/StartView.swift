//
//  StartView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/12/24.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        if (userManager.isUserLoggedIn()) {
            StartQuizView()
        } else {
            SigninView()
        }
    }
}

#Preview {
    StartView().environmentObject(UserManager())
}
