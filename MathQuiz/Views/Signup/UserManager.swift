//
//  SignupViewModel.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class UserManager: ObservableObject {
    @Published var signedIn: Bool = false
    private (set) var user: User?
    
    func isUserLoggedIn() -> Bool {
        return signedIn
    }
    
    func listenForStateChange() {
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("User logged in \(String(describing: user?.uid))")
                let db = Firestore.firestore()
                Task {
                    do {
                        let userDoc = try await db.collection("Users").document(user!.uid).getDocument()
                        print("UserDoc = \(userDoc.exists)")
                        if userDoc.exists {
                            print(userDoc.data()!["Name"] ?? "NA")
                            
                            DispatchQueue.main.async {
                                self.user = User(
                                    uid: user!.uid,
                                    name: userDoc.data()!["Name"] as! String,
                                    email: userDoc.data()!["Email"] as! String)
                                
                                self.signedIn = true
                            }
                        } else {
                            print("Document does not exist for user: \(user!.uid)")
                        }
                    } catch {
                        print("Error finding User data \(user!.uid)")
                    }
                }
            } else {
                self.signedIn = false
                print("User logged out")
            }
        }
    }
    
    func createAccount(name: String, email: String, password: String, completion: (_ uid: String?, _ err: Error?) -> Void ) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
            if let e = err {
                print("Failed to create user with email \(email), \(e.localizedDescription)")
            } else {
                if let result = authResult {
                    print("Account created \(String(describing: result.user.uid))")
                    
                    let db = Firestore.firestore()
                    db.collection("Users").document(result.user.uid).setData([
                        "Name": name,
                        "Email": email,
                        "CreatedAt": Date()
                    ])
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, err in
            if let e = err {
                print("Error signing in \(e.localizedDescription)")
            } else {
                print("Signed in successfully")
            }
        })
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch(let err){
            completion(err)
            print("Error signing out")
        }
    }
}
