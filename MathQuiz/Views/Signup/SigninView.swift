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
    @State var email:String = ""
    @State var password:String = ""
    @State var showSignup = false
    
    @State private var path = [Int]()
    
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                VStack(spacing: 15) {
                    InputField(icon: "envelope", placeholder: "Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    HStack {
                        InputField(
                            icon: "lock",
                            placeholder: "Password",
                            text: $password,
                            isSecure: true
                        )
                    }
                }.padding(.horizontal)
                
                Button(action: signin) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Do not have an account?")
                    NavigationLink("Sign Up", destination: SignupView())
                }
                .font(.subheadline)
            }.navigationDestination(
                        isPresented: Binding(
                            get: { userManager.isUserLoggedIn() }, set: {_ in} )) {
                        StartQuizView()
                    }
        }.navigationBarBackButtonHidden()
    }
    
    
    func signin() {
        userManager.signIn(email: email, password: password)
    }
}

#Preview {
    SigninView().environmentObject(UserManager())
}
