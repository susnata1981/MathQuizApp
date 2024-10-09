//
//  ChoiceRow.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/30/24.
//

import SwiftUI

struct ChoiceRow: View {
    var choices: [String]
    
    var body: some View {
        
        GridRow {
            ForEach(choices, id: \.self) { item in
                Button(action: {
                }, label: {
                    Text(item)
                        .padding(10)
                        .background(Color.brown)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                })
            }
        }
    }
    
}

#Preview {
    ChoiceRow(choices: ["24", "12", "23"])
}
