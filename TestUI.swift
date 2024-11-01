//
//  TestUI.swift
//  MathQuiz
//
//  Created by Susnata Basak on 11/1/24.
//

import SwiftUI

struct TestUI: View {
    var body: some View {
//        ScrollView(.vertical) {
            
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .shadow(color: .black, radius: 3.0, x: 5, y: 5)
                    .frame(maxHeight: 320)
                    .padding()
                
                Spacer()
                
                HStack(alignment: .top) {
                    Button(action: {}) {
                        Text("Submit")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.cyan)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {}) {
                        Text("Submit")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
            }
            
//        }
    }
}

#Preview {
    TestUI()
}
