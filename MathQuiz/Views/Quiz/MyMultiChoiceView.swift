//
//  MyMultiChoiceView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import SwiftUI

struct MyMultiChoiceView: View {
    @Binding var problem: Problem?
    var isReviewMode = false
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(problem?.multiChoiceItems ?? [], id: \.self) { choice in
                ChoiceRowView(isReviewMode: isReviewMode, item: choice)
            }
        }
    }
}

//#Preview {
//    MyMultiChoiceView()
//}
