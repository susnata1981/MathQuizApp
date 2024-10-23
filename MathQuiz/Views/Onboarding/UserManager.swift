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
    private(set) var user: User?
    
    struct Constants {
        static let userSignedInKey = "UserSignedIn"
    }
    
    func isUserLoggedIn() -> Bool {
        return signedIn
    }
    
    @MainActor
    func listenForStateChange() {
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            Task {
                do {
                    if let username = user?.uid {
                        print("Auth state changed for \(username)!!!")
                        
                        let db = Firestore.firestore()
                        let userRef = db.collection("Users").document(username)
                        
                        
                        self.user = try await userRef.getDocument(as: User.self)
                        print("User = \(username)")
                        UserDefaults.standard.set(true, forKey: Constants.userSignedInKey)
                        self.signedIn = true
                    } else {
                        UserDefaults.standard.set(false, forKey: Constants.userSignedInKey)
                    }
                } catch {
                    print("Failed to sign in for \(String(describing: user?.uid))")
                }
            }
        }
    }
    
    
    func createAccount(user: User, completion: (_ authResult: String?, _ err: Error?) -> Void) async {
        do {
            let db = Firestore.firestore()
            let userRef = try await db.collection("Users").document(user.username).getDocument()
            
            if userRef.exists {
                completion(nil, DuplicateUsername(errDescription: "Duplicate username \(user.username)"))
                return
            }
            
            let token = try await generateCustomToken(username: user.username)
            
            try db.collection("Users").document(user.username).setData(from: user)
            print("User created \(user)")

            let _ = try await Auth.auth().signIn(withCustomToken: token)
        } catch(let error) {
            print("Failed to create account for \(user) error: \(error.localizedDescription)")
        }
    }

     
    private func generateCustomToken(username: String) async throws -> String {
        if let url = URL(string: "https://generateaccesstoken-7shv5rmu5a-uc.a.run.app") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let json = ["username": username]
            print("Initial json = \(json)")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json)
                let temp = try JSONSerialization.data(withJSONObject: json)
                print(temp)
//                print("request - \(request.httpBody)")
                
                // Use async URLSession for better error handling
                let (data, response) = try await URLSession.shared.data(for: request)
                
                // Decode the token response
                return try JSONDecoder().decode(TokenResponse.self, from: data).token
            } catch {
                // Handle errors from JSONSerialization, network request, or decoding
                print("Error: \(error.localizedDescription)")
            }
        }
        throw RuntimeError("Failed to generate token")
    }
    
    func signIn(username: String, pin: String) async -> Result {
        do {
            let db = Firestore.firestore()
            let userRef = try await db.collection("Users").document(username).getDocument()
            
            if userRef.exists {
                let user = try userRef.data(as: User.self)
                print("Found user \(user.name)")
                
                if user.pin == pin {
                    let token = try await generateCustomToken(username: username)

                    let result = try await Auth.auth().signIn(withCustomToken: token)
                    print(result)
                    
                    return .success
                }
            }
        } catch (let err) {
            print("Error signing in \(err.localizedDescription)")
        }
        
        return .error
    }
                           
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "UserSignedIn")
            self.signedIn = false
            completion(nil)
        } catch(let err){
            completion(err)
            print("Error signing out")
        }
    }
    
    func isUsernameValid(_ username: String) async -> Bool {
        do {
            print("Checking username: \(username)")
            let snapshot = try await Firestore.firestore().collection("Users").document(username).getDocument()
            print("Checking username: \(username), result = \(snapshot.exists)")
            return !snapshot.exists
        } catch {
            print("Error checking username uniqueness: \(error)")
            return false
        }
    }
}
                       
class DuplicateUsername: Error {
    var errDescription: String
    
    init(errDescription: String) {
        self.errDescription = errDescription
    }
}


struct TokenResponse: Codable {
    var token: String
}

struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}

enum Result {
    case success, error
}
