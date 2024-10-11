////
////  SignupView.swift
////  MathQuiz
////
////  Created by Susnata Basak on 9/8/24.
////
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

struct SignupView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                VStack(spacing: 15) {
                    InputField(icon: "person", placeholder: "Name", text: $name)
                    InputField(icon: "envelope", placeholder: "Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    HStack {
                        InputField(
                            icon: "lock",
                            placeholder: "Password",
                            text: $password,
                            isSecure: !showPassword
                        )
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    InputField(
                        icon: "lock",
                        placeholder: "Confirm Password",
                        text: $confirmPassword,
                        isSecure: true
                    )
                }
                .padding(.horizontal)
                
                Button(action: signup) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1 : 0.6)
                
                HStack {
                    Text("Already have an account?")
                    NavigationLink("Sign In", destination: SigninView())
                        .foregroundColor(.blue)
                }.font(.subheadline)
                
                Spacer()
            }
//            .navigationDestination(isPresented: $userManager.signedIn) {
//                let _ = print("Navigation destination: SQV")
//                StartQuizView()
//            }
            .navigationDestination(isPresented: Binding(get: {
                userManager.isUserLoggedIn()
            }, set: { _ in } )) {
                let _ = print("Navigation destination: SQV")
                StartQuizView()
            }
           
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if userManager.isUserLoggedIn() {
                    Button("Sign Out") {
                        userManager.signOut { error in
                            if let error = error {
                                showAlert(message: "Error signing out: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmPassword && password.count >= 6
    }
    
    private func signup() {
        userManager.createAccount(name: name, email: email, password: password) { uid, err in
            if let error = err {
                showAlert(message: "Error creating account: \(error.localizedDescription)")
            } else {
                // Handle successful signup, e.g., navigate to the main app view
                print(uid!)
            }
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
                .environmentObject(UserManager())
        }
    }
}
