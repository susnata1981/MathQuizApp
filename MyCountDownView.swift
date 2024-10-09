//
//  MyCountDownView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/15/24.
//

import SwiftUI

struct MyCountDownView: View {
    @State var count: Int = 3
    
    @State var scale = CGFloat(1)
    @State var animate = false
    
    @Binding var showCountdown: Bool
    var completion: () -> Void
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var content: String {
        get {
            if count == 0 {
                "Go"
            } else {
                String(count)
            }
        }
    }
    
    private var rotation: Angle {
        get {
            if count == 0 {
                return Angle(degrees: 0.0)
            }
                
            return animate ? Angle(degrees: 360) : Angle(degrees: 0)
        }
    }
    
    var body: some View {
        Circle()
            .fill(.gray)
            .opacity(0.5)
            .overlay(content: {
                Text(content)
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                    .font(.system(size: 80.0))
                    .scaleEffect(animate ? 3 * scale : scale)
                    .rotationEffect(rotation)
                    .opacity(animate ? 1 : 0)
            })
            .zIndex(1.0)
            .onReceive(timer) { _ in
                count = count - 1
                withAnimation(.spring(duration: 0.5, bounce: 0.5), {
                    animate = true
                }, completion: {
                    animate = false
                })
                
                if count < 0 {
                    showCountdown = false
                    completion()
                }
            }.onAppear {
                withAnimation(.spring(duration: 0.5, bounce: 0.5), {
                    animate = true
                }, completion: {
                    animate = false
                })
            }
    }
}

//#Preview {
//    MyCountDownView()
//}
