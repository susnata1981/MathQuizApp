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
                    Text("Math Quiz")
                        .font(theme.fonts.large)
                        .fontWeight(.bold)
                        .foregroundColor(theme.colors.primary)
                        .padding(.top, 50)
                    
                   
                    VStack(spacing: 15) {
                        HStack {
//                            InputField(icon: "person.fill", placeholder: "username", text: $username)
                            IconInputField(icon: "person.fill", placeholder: "Username", text: $username,                        iconColor: theme.colors.primary)
                                .autocorrectionDisabled()
                                .foregroundColor(theme.colors.text)
                                .autocapitalization(.none)
                                .onChange(of: username) {
                                    resetErrorMessage()
                                }
                        }
                        
                        HStack {
                            IconInputField(icon: "lock.fill", placeholder: "Pin", text: $pin,
                                           iconColor: theme.colors.primary, isSecure: true)
                            .foregroundColor(theme.colors.text)
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
                            Text("SIGN IN")
                                .font(theme.fonts.regular)
                                .foregroundColor(isFormValid && !isSigningIn ? .white : .white)
                        }
                    }
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(isFormValid && !isSigningIn ? theme.colors.primary: theme.colors.primary)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(!isFormValid || isSigningIn)
                                        
                    VStack {
                        Text("Don't have an account yet?")
                            .font(.subheadline)
                            .foregroundColor(theme.colors.text)
                        
                        HStack {
                            NavigationLink(destination: SignupView()) {
                                Text("Sign up")
                                    .foregroundColor(theme.colors.accent)
                                    .font(theme.fonts.regular)
                                    .fontWeight(.bold)
                            }
                        }
                    }.padding(.top, 24)
                }.navigationDestination(
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
                    .environmentObject(Theme.theme5)
                    .previewDisplayName("Default (Light)")
                
                // With error message
                SigninView(errorMessage: "Invalid username or pin", showErrorMessage: true)
                    .environmentObject(UserManager())
                    .environmentObject(Theme.theme5)
                    .previewDisplayName("Error State")
                
                // Signing in state
                SigninView(isSigningIn: true)
                    .environmentObject(UserManager())
                    .environmentObject(Theme.theme5)
                    .previewDisplayName("Signing In")
                
                // Dark mode
                SigninView()
                    .environmentObject(UserManager())
                    .environmentObject(Theme.theme5)
                    .preferredColorScheme(.dark)
                    .previewDisplayName("Dark Mode")
            }
        }
    }
