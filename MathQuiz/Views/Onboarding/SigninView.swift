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

struct SigninView: View {
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
    
    init(isSigningIn: Bool = false, errorMessage: String = "", showErrorMessage: Bool = false) {
        _isSigningIn = State(initialValue: isSigningIn)
        _errorMessage = State(initialValue: errorMessage)
        _showErrorMessage = State(initialValue: showErrorMessage)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                theme.colors.background.ignoresSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Sign In")
                        .font(theme.fonts.large)
                        .fontWeight(.bold)
                        .foregroundColor(theme.colors.accent)
                        .padding(.top, 50)
                    
                   
                    VStack(spacing: 15) {
                        HStack {
                            InputField(icon: "person.fill", placeholder: "username", text: $username)
                                .autocorrectionDisabled()
                                .foregroundColor(theme.colors.accent)
                                .autocapitalization(.none)
                                .onChange(of: username) {
                                    resetErrorMessage()
                                }
                        }
                        
                        HStack {
                            InputField(
                                icon: "lock.fill",
                                placeholder: "pin",
                                text: $pin,
                                isSecure: true
                            )
                            .foregroundColor(theme.colors.accent)
                            .keyboardType(.numberPad)
                            .onChange(of: pin) {
                                showErrorMessage = false
                                errorMessage = ""
                            }
                        }
                    }.padding(.horizontal)
                    
                    Text(errorMessage)
                        .disabled(!showErrorMessage)
                        .font(theme.fonts.regular)
                        .fontWeight(.bold)
                        .foregroundColor(theme.colors.error)
                    
                    Button(action: signin) {
                        if isSigningIn {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign In")
                                .font(theme.fonts.regular)
                                .foregroundColor(isFormValid && !isSigningIn ? theme.colors.background: theme.colors.accent)
                        }
                    }
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(isFormValid && !isSigningIn ? theme.colors.primary: theme.colors.disabled)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(!isFormValid || isSigningIn)
                    
                    HStack {
                        NavigationLink(destination: SigninView()) {
                            Text("Sign Up")
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(theme.colors.disabled.opacity(0.5))
                                .foregroundColor(theme.colors.accent)
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .font(theme.fonts.regular)
                        }
                    }
                }
                    .navigationDestination(
                        isPresented: Binding(
                            get: { userManager.isUserLoggedIn() },
                            set: {_ in }
                        )
                    ) {
                        StartQuizView()
                    }
                }
            }.navigationBarBackButtonHidden()
        }
        
        var isFormValid: Bool {
            !username.isEmpty && !pin.isEmpty
        }
        
        func resetErrorMessage() {
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
    
    struct SigninView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                // Default state
                SigninView()
                    .environmentObject(UserManager())
                    .environmentObject(Theme.theme1)
                    .previewDisplayName("Default (Light)")
                
                // With error message
                SigninView(errorMessage: "Invalid username or pin", showErrorMessage: true)
                    .environmentObject(UserManager())
                    .environmentObject(Theme.theme1)
                    .previewDisplayName("Error State")
                
                // Signing in state
                SigninView(isSigningIn: true)
                    .environmentObject(UserManager())
                    .environmentObject(Theme.theme1)
                    .previewDisplayName("Signing In")
                
                // Dark mode
                SigninView()
                    .environmentObject(UserManager())
                    .environmentObject(Theme.theme1)
                    .preferredColorScheme(.dark)
                    .previewDisplayName("Dark Mode")
            }
        }
    }
