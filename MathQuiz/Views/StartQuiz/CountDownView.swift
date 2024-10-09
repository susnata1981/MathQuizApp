//
//  CountDownView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/15/24.
//

import SwiftUI

struct CountdownView: View {
    @Binding var isPresented: Bool
    let onFinish: () -> Void
    
    @State private var countdown = 3
    @State private var scale: CGFloat = 4
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if countdown > 0 {
                    Text("\(countdown)")
                        .font(.system(size: 150, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .rotationEffect(.degrees(rotation))
                } else {
                    Text("Go!")
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                scale = 1
                opacity = 1
                rotation = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scale = 0.5
                    opacity = 0
                    rotation = -90
                }
            }
            
            if countdown > 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    countdown -= 1
                    scale = 4
                    opacity = 0
                    rotation = 90
                }
            } else if countdown == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    countdown = 0
                    scale = 4
                    opacity = 0
                    rotation = 90
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                    onFinish()
                }
            }
        }
    }
}

/*
 struct ContentView: View {
 @State private var showCountdown = false
 @State private var gameStarted = false
 
 var body: some View {
 ZStack {
 VStack {
 Button("Start Game") {
 showCountdown = true
 }
 .padding()
 .background(Color.blue)
 .foregroundColor(.white)
 .cornerRadius(10)
 
 if gameStarted {
 Text("Game Started!")
 .font(.largeTitle)
 .foregroundColor(.green)
 }
 }
 
 if showCountdown {
 CountdownView(isPresented: $showCountdown) {
 gameStarted = true
 }
 .transition(.opacity)
 .animation(.easeInOut, value: showCountdown)
 }
 }
 }
 }
 
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
 */
