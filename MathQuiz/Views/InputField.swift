//
//  InputField.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/14/24.
//

import SwiftUI

struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    @State var input = ""
    return InputField(icon: "person", placeholder: "Enter...", text: $input)
}
