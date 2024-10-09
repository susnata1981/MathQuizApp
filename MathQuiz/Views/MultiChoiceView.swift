//
//  MultiChoiceView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/4/24.
//

import SwiftUI

struct MultiChoiceView: View {
    
//    @Environment(QuizViewModel.self) var viewModel
    @EnvironmentObject var viewModel: QuizViewModel
    @State var value = Color.gray
    
    var body: some View {
        
        Text("MCV")
        /*let columns = [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]
        if let _ = viewModel.ctx.currentProblem {
            LazyVGrid(columns: columns, alignment: .center, spacing: 0, content: {
                
                ForEach(
                    viewModel.currentProblem!.getMultiChoiceItems(), id: \.self) { item in
                        
                        // User select answer
                        Button(action: {
                            print("User clicked on \(item.content)")
                            withAnimation() {
//                                viewModel.selectedAnswer(
//                                    multiChoiceItem: item,
//                                    answer: Answer(value: item.content ?? "0"))
//                                value = Color.green
                            }
                        }, label: {
                            Text(item.content)
                                .padding(12)
                                .background(item.isSelected ? value: Color.brown)
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                                .cornerRadius(8)
                            
                        }).padding([.top, .bottom], 20)
                    }
            })
        } else {
            ProgressView()
        }*/
    }
}

//#Preview {
//    return MultiChoiceView()
//}
