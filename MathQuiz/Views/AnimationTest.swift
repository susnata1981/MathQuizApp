////
////  AnimationTest.swift
////  MathQuiz
////
////  Created by Susnata Basak on 9/19/24.
////
//
//import SwiftUI
//
//enum Movement: CaseIterable {
//    case start, right, left
//    
//    var offset: CGFloat {
//        switch(self) {
//        case .start: CGFloat(0)
//        case .left: CGFloat(-50)
//        case .right: CGFloat(50)
//        }
//    }
//}
//
//struct AnimationTest: View {
//    
//    @State var start = false
//    @State var xoffset = CGFloat(0)
//    
//    var body: some View {
//        
//        Rectangle()
//            .fill(.cyan)
//            .frame(width: 100, height: 100)
//            .offset(x: xoffset)
//            .phaseAnimator(Movement.allCases, trigger: start, content: { content, phase in
//                print("Phase =\(phase)")
//                if phase == .left {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        start.toggle()
//                    }
//                }
//                
//                return content.offset(x: phase.offset, y:0)
//            }, animation: { phase in
//                return .easeIn(duration: 0.5).speed(5)
//            })
//            .onTapGesture {
//                start.toggle()
//                
//            }
//    }
//}
//
//#Preview {
//    AnimationTest()
//}


import SwiftUI

struct ShakeAnimationView: View {
    @State private var shakes: Int = 0
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 200, height: 100)
            .offset(x: shakes % 2 == 0 ? 50 : -50)  // Shakes the rectangle left and right
           
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).speed(2).repeatCount(50)) {
                    shakes += 1  // Trigger the shake when the view appears
                }
            }
    }
}

struct ShakeAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ShakeAnimationView()
    }
}
