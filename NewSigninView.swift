//
//  SigninView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 9/8/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

struct NewSigninView: View {
    @State private var username: String = ""
    @State private var pin: String = ""
    @State private var showSignup = false
    @State private var path = [Int]()
    @State private var usernameMessage = ""
    @State private var isSigningIn = false
    @State private var errorMessage = ""
    @State private var showErrorMessage = false
    
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var theme: Theme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("New Sign In")
                    .font(theme.fonts.large)
                    .fontWeight(.bold)
                    .foregroundColor(theme.colors.accent)
                    .padding(.top, 50)
                
                VStack(spacing: 15) {
                    HStack {
                        InputField(icon: "person.fill", placeholder: "username", text: $username)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .onChange(of: username) {
                                resetErrorMessage()
                            }
                    }
                    
                    HStack {
                        InputField(
                            icon: "lock",
                            placeholder: "pin",
                            text: $pin,
                            isSecure: true
                        ).onChange(of: pin) {
                            showErrorMessage = false
                            errorMessage = ""
                        }
                    }
                }.padding(.horizontal)
                
                Button(action: signin) {
                    if isSigningIn {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign In")
                            .font(theme.fonts.regular)
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(isFormValid && !isSigningIn ? theme.colors.accent: theme.colors.disabled)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(!isFormValid || isSigningIn)
                
                Text(errorMessage)
                    .disabled(!showErrorMessage)
                    .font(theme.fonts.regular)
                    .fontWeight(.bold)
                    .foregroundColor(theme.colors.error)
                
                HStack {
                    Text("Do not have an account?")
                    NavigationLink("Sign Up", destination: NewSignupView())
                        .foregroundColor(theme.colors.accent)
                }
                .font(theme.fonts.caption)
            }.navigationDestination(
                isPresented: Binding(
                    get: { userManager.isUserLoggedIn() },
                    set: {_ in }
                )
            ) {
                StartQuizView()
            }
        }.navigationBarBackButtonHidden()
    }
    
    private var isFormValid: Bool {
        !username.isEmpty && !pin.isEmpty
    }
    
    private func resetErrorMessage() {
        showErrorMessage = false
        errorMessage = ""
    }
    
    func signin() {
        isSigningIn = true
        showErrorMessage = false
        errorMessage = ""
        
        Task {
            let result = await userManager.signIn(username: username, pin: pin)
            switch(result) {
            case .success:
                isSigningIn = false
            case .error:
                isSigningIn = false
                errorMessage = "Invalid username or pin"
                showErrorMessage = true
            }
            
        }
    }
}

struct NewSigninView_Previews: PreviewProvider {
    static var previews: some View {
        NewSigninView()
            .environmentObject(UserManager())
            .environmentObject(Theme.theme1)
    }
}
