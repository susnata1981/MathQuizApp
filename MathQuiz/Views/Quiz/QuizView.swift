////
////  ContentView.swift
////  MathQuiz
////
////  Created by Susnata Basak on 8/30/24.
////
//

import SwiftUI

struct QuizView: View {
    
    @EnvironmentObject var viewModel: QuizViewModel
    @EnvironmentObject var session: Session
    
    @State var shake = false
    
    struct Constants {
        static let totalProblems = 3
        static let multiChoiceCount = 4
    }
    
    var body: some View {
        
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.2), .pink.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                ProblemSectionView(
                    indexOfProblem: viewModel.ctx.currentIndex,
                    problem: viewModel.currentProblem)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
//                if viewModel.currentProblem != nil {
                    HStack {
                        MyMultiChoiceView(problem: $viewModel.currProblem, isReviewMode: false)
                    }.padding()
//                }
                
                nextButtonView
                
                Spacer()
            }
            .navigationDestination(isPresented: Binding(
                get: { viewModel.showResults },
                set: { viewModel.showResults = $0 }
            )) {
                ResultView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            viewModel.session = session
            print("Current problem = \(viewModel.currProblem)")
        }
    }
    
    var nextButtonView: some View {
        NavigationLink(value: viewModel.quiz) {
            Button(action: {
                viewModel.handleNextButtonClick()
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

//struct ChoiceRowView: View {
//    @Environment(QuizViewModel.self) var viewModel
//
//    var item: MultiChoiceItem
//    @State var isWrongAnswer = false
//    @State var bounce = true
//
//    enum Shake: CaseIterable {
//        case start, right, left
//
//        var offset: Int {
//            switch(self) {
//                case .right: 10
//                case .left: -10
//                case .start: 0
//            }
//        }
//    }
//
//    func getShakeAnimationStates() -> Array<Shake> {
//        var states = Array(repeating: Shake.allCases, count: 3).flatMap{ $0 }.filter{
//            $0 != .start
//        }
//        states.insert(.start, at: 0)
//        states.append(.start)
//        return states
//    }
//    
//    var body: some View {
//        
//        Group {
//            Button(action: {
//                viewModel.handleChoiceSelection(choice: item)
//                print("\(item.content) is correct = \(viewModel.isSelectionCorrect(item))")
//                isWrongAnswer = !viewModel.isSelectionCorrect(item)
//            }) {
//                Text(item.content)
//                    .font(.custom("Comic Sans MS", size: 24))
//                    .fontWeight(.bold)
//                    .foregroundColor(
//                        viewModel.isChoiceSelected(item) ? .white : viewModel.textColor)
//                    .frame(width: 120, height: 60)
//                    .background(
//                        RoundedRectangle(cornerRadius: 15)
//                            .fill(viewModel.isChoiceSelected(item) ? viewModel.selectedChoiceBackgroundColor : Color.white)
//                            .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 3)
//                    )
//            }
//            .disabled(viewModel.isChoiceSelected(item))
//            .phaseAnimator(getShakeAnimationStates(), trigger: isWrongAnswer, content: { content, phase in
//                return content.offset(x: CGFloat(phase.offset))
//            }, animation: { phase in
//                return .easeIn(duration: 0.3).speed(5.0)
//            })
//        }
//    }
//}


#Preview {
    QuizView()
        .environment(User(uid: "AABSBS", name: "Adi", email: "adi@gmail.com"))
//        .environment(QuizViewModel())
}
