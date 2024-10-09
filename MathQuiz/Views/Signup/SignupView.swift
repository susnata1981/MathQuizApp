////
////  SignupView.swift
////  MathQuiz
////
////  Created by Susnata Basak on 9/8/24.
////
//
//import SwiftUI
//import FirebaseFirestore
//import FirebaseAuth
//import FirebaseCore
//
//struct SignupView: View {
//    private static var SIGN_IN_PAGE = 0
//    private static var QUIZ_VIEW_PAGE = 1
//
//    @State private var path = [Int]()
//
//    @State var isUsernameValid:Bool = false
//
//    @State var name:String = ""
//    @State var email:String = ""
//    @State var password:String = ""
//    @State var transitionToStartQuizView = false
//    @State var showSignInView = false
//
//    @Environment(UserManager.self) var userManager
//
//    var body: some View {
//
//        NavigationStack {
//
//            Form {
//                Section {
//                    InputTextField(
//                        labelName: "Name", imageName: "person", input: $name)
//
//                    InputTextField(
//                        labelName: "Email", imageName: "person", input: $email)
//
//                    SecureField("Password", text: $password)
//                        .mySecureField()
//
//                }.padding()
//
//                Section {
//                    HStack {
//                        Spacer()
//
//                        Button("Signup") {
//                            signup()
//                        }
//
//                        Spacer()
//                    }
//                }
//
//                Section {
//
//                    HStack {
//                        Text("Already have an account")
//                            .plain()
//
//                        NavigationLink(destination: SigninView()) {
//                            Text("sign in")
//                                .foregroundColor(.blue)
//                                .font(.body)
//                                .border(.black)
//                        }
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Sign Out") {
//                        userManager.signOut(completion: {error in
//                            print("Error = \(String(describing: error))")
//                        })
//                    }.opacity(userManager.isUserLoggedIn() ? 1 : 0)
//                }
//            }
//        }
//    }
//
//    func signup() {
//        userManager.createAccount(
//            name: name,
//            email: email,
//            password: password)
//        path = [1]
//    }
//}
//
//struct InputTextField : View {
//    var labelName: String
//    var imageName: String
//
//    @Binding var input:String
//
//    var body: some View {
//        HStack {
//            Image(systemName: imageName)
//            TextField(labelName, text: $input)
//                .padding(4)
//                .font(.body)
//                .cornerRadius(3)
//        }
//    }
//}
//
//extension SecureField {
//    func mySecureField() -> some View {
//        self.padding(2)
//            .font(.body)
//            .cornerRadius(3)
//    }
//}
//
//extension Text {
//    func plain() -> some View {
//        modifier(PlainSecureField())
//    }
//}
//
//struct PlainSecureField : ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.title)
//            .padding(4)
//            .cornerRadius(3.0)
//    }
//}
//
//#Preview {
//    return SignupView(name: "", email: "", password: "")
//}


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
    
//    @StateObject var navManager = NavigationManager()

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
//        .environmentObject(navManager)
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

//struct InputField: View {
//    let icon: String
//    let placeholder: String
//    @Binding var text: String
//    var isSecure: Bool = false
//
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(.secondary)
//
//            if isSecure {
//                SecureField(placeholder, text: $text)
//            } else {
//                TextField(placeholder, text: $text)
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(10)
//    }
//}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
                .environmentObject(UserManager())
        }
    }
}
