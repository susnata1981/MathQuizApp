//
//  SignView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/11/24.
//

import SwiftUI

struct SignView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            
            Text("Sign In")
                .font(.title2)
            
            HStack {
                Spacer()
                
                Button("Sign In") {
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    SignView()
}
