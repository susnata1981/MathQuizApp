//
//  User.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/31/24.
//

import Foundation

//@Observable class User : Hashable {
//    var uid: String?
//    let name: String
//    let email: String
//    
//    init(uid: String, name: String, email: String) {
//        self.uid = uid
//        self.name = name
//        self.email = email
//    }
//    
//    static func == (lhs: User, rhs: User) -> Bool {
//        lhs.uid == rhs.uid && lhs.name == rhs.name && lhs.email == rhs.email
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(uid)
//        hasher.combine(name)
//        hasher.combine(email)
//    }
//}


@Observable class User : Hashable, Encodable, Decodable {
    var accessToken: String?
    let username: String
    let pin: String
    let name: String
    
    init(username: String, pin: String, name: String) {
        self.username = username
        self.pin = pin
        self.name = name
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.username == rhs.username
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(username)
        hasher.combine(pin)
        hasher.combine(name)
    }
    
    var debugDescription: String {
       return "User: \(name), Username: \(username)"
    }
}

