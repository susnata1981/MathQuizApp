//
//  ReviewResultView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/29/24.
//

import SwiftUI

struct ReviewResultView: View {
    
    @EnvironmentObject var session: Session
    @State var index = 0
    @State var currProblem: Problem?
    @State var startNewGame = false
    
    var body: some View {
        VStack {
            
            if (currProblem != nil) {
                ProblemSectionView(indexOfProblem: (index + 1), problem: currProblem)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                HStack {
                    MyMultiChoiceView(problem: $currProblem, isReviewMode: true)
                }.padding()
                
                Spacer()
                
                Text("Correct Answer is \(currProblem!.answer)")
                    .font(.custom("Comic Sans MS", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                
                Spacer()
                
                nextButtonView
            }
        }.onAppear {
            currProblem = session.quiz!.getProblem(index: index)!
        }.navigationDestination(isPresented: $startNewGame, destination: {
            CompletedReviewView()
        })
    }
    
    var nextButtonView: some View {
        NavigationLink(value: session.quiz!) {
            Button(action: {
                index = index + 1
                if index < session.quiz!.getProblemCount() {
                    currProblem = session.quiz!.getProblem(index: index)!
                } else {
                    startNewGame = true
                }
            }) {
                Text("Next")
                    .font(.custom("Comic Sans MS", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(25)
                    .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 3)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    ReviewResultView()
//}
