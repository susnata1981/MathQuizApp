import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

struct SignupView: View {
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var pin: String = ""
    @State private var confirmPin: String = ""
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isUsernameValid = false
    @State private var usernameMessage = ""
    @State private var isSigningUp = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var theme: Theme
    
    var body: some View {
        NavigationView {
            ZStack {
                
                theme.colors.background.ignoresSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(theme.fonts.large)
                        .foregroundColor(theme.colors.primary)
                        .padding(.top, 24)
                    
                    VStack(spacing: 15) {
                        HStack {
                            
                            IconInputField(icon: "person.fill", placeholder: "Name", text: $name, iconColor: theme.colors.primary)

                            
                            if !name.isEmpty {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(theme.colors.success)
                            }
                        }
                        
                        HStack {
                            
                            IconInputField(icon: "person.fill", placeholder: "Username", text: $username, iconColor: theme.colors.primary)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                                .onChange(of: username) { _ in
                                    if !username.isEmpty {
                                        validateUsername()
                                    }
                                }
                            
                            if !username.isEmpty {
                                Image(systemName: isUsernameValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(isUsernameValid ? theme.colors.success : theme.colors.error)
                            }
                        }
                                                
                        HStack {
                            
                            IconInputField(icon: "lock.fill", placeholder: "Pin", text: $pin,                        iconColor: theme.colors.primary, isSecure: !showPassword).keyboardType(.numberPad)

                            
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(theme.colors.primary)
                            }
                        }
                        
                        IconInputField(icon: "lock.fill", placeholder: "Confirm Pin", text: $confirmPin,
                                       iconColor: theme.colors.primary, isSecure: !showPassword).keyboardType(.numberPad)

                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: signup) {
                        if isSigningUp {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign Up")
                                .foregroundColor(.white)
//                                .foregroundColor(isFormValid && !isSigningUp ? theme.colors.background : theme.colors.accent)
                        }
                    }
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
//                    .background(isFormValid && !isSigningUp ? theme.colors.accent : theme.colors.disabled)
                    .background(theme.colors.primary)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(!isFormValid || isSigningUp)
                    
//                    HStack {
//                        NavigationLink(destination: SigninView()) {
//                            Text("Sign In")
//                            .frame(height: 55)
//                            .frame(maxWidth: .infinity)
//                            .background(.gray.opacity(0.5))
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                        }
//                    }
                    
                    VStack {
                        Text("Already have an account yet?")
                            .font(.subheadline)
                            .foregroundColor(theme.colors.text)
                        
                        HStack {
                            NavigationLink(destination: SigninView()) {
                                Text("Sign in")
                                    .foregroundColor(theme.colors.accent)
                                    .font(theme.fonts.regular)
                                    .fontWeight(.bold)
                            }
                        }
                    }.padding(.top, 32)

                    
                    Spacer()
                }
                .padding()
            }
            .navigationDestination(isPresented: Binding(get: {
                userManager.isUserLoggedIn()
            }, set: { _ in } )) {
                StartQuizView()
            }
        }
        .navigationBarBackButtonHidden()
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
                    .foregroundColor(theme.colors.primary)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !username.isEmpty && isUsernameValid && !pin.isEmpty && pin == confirmPin && pin.count >= 4
    }
    
    private func signup() {
        isSigningUp = true
        let user = User(username: username, pin: pin, name: name)
        Task {
            await userManager.createAccount(user: user) { uid, err in
                isSigningUp = false
                if let error = err {
                    showAlert(message: "Error creating account: \(error.localizedDescription)")
                } else {
                    // Handle successful signup, e.g., navigate to the main app view
                    print(uid!)
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func validateUsername() {
        Task {
            let isValid = await userManager.isUsernameValid(username)
            isUsernameValid = isValid
            usernameMessage = isValid ? "Username is available" : "Username is already taken"
        }
    }
}

struct IconInputField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var iconColor: Color = .blue // Default color
    var isSecure = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor) // Apply color to the icon
            if (isSecure) {
                SecureField(placeholder, text: $text).padding(.leading, 8)
            } else {
                TextField(placeholder, text: $text).padding(.leading, 8)
            }
                
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemBackground)))
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
                .environmentObject(UserManager())
                .environmentObject(Theme.theme5)
                .colorScheme(.light)
        }
    }
}

