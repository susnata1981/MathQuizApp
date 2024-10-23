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
                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(theme.fonts.large)
                        .foregroundColor(theme.colors.accent)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                    
                    VStack(spacing: 15) {
                        HStack {
                            InputField(icon: "person", placeholder: "Name", text: $name)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                            
                            if !name.isEmpty {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(theme.colors.success)
                            }
                        }
                        
                        HStack {
                            InputField(icon: "person.fill", placeholder: "Username", text: $username)
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
                        
                        if !username.isEmpty {
                            Text(usernameMessage)
                                .font(theme.fonts.caption)
                                .foregroundColor(isUsernameValid ? theme.colors.success : theme.colors.error)
                        }
                        
                        HStack {
                            InputField(
                                icon: "lock",
                                placeholder: "Pin",
                                text: $pin,
                                isSecure: !showPassword
                            )
                            
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(theme.colors.secondary)
                            }
                        }
                        
                        InputField(
                            icon: "lock",
                            placeholder: "Confirm Pin",
                            text: $confirmPin,
                            isSecure: true
                        )
                    }
                    .padding(.horizontal)
                    
                    Button(action: signup) {
                        if isSigningUp {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign Up")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(isFormValid && !isSigningUp ? theme.colors.accent : theme.colors.disabled)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(!isFormValid || isSigningUp)
                    
                    HStack {
                        Text("Already have an account?")
                        NavigationLink("Sign In", destination: SigninView())
                            .foregroundColor(theme.colors.accent)
                    }.font(theme.fonts.regular)
                    
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

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
                .environmentObject(UserManager())
                .environmentObject(Theme.theme1)
        }
    }
}
