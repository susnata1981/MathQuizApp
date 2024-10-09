//
//  User.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/31/24.
//

import Foundation

@Observable class User : Hashable {
    var uid: String?
    let name: String
    let email: String
    
    init(uid: String, name: String, email: String) {
        self.uid = uid
        self.name = name
        self.email = email
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.uid == rhs.uid && lhs.name == rhs.name && lhs.email == rhs.email
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(name)
        hasher.combine(email)
    }
}
