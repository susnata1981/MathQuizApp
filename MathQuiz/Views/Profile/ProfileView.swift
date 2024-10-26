//
//  ProfileView.swift
//  MathQuiz
//
//  Created by Susnata Basak on 10/2/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var theme: Theme
    @State var profileVM = ProfileViewModel()
    @State private var showingSignOutAlert = false
    
    var body: some View {
        ZStack {
            theme.colors.background.edgesIgnoringSafeArea(.all)
            
            HistoryView(quizzes: profileVM.quizzes)
        }
//        .navigationTitle("Profile")
//        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                signOutButton
            }
        }
        .onAppear(perform: {
            Task { await loadQuizzes() }
        })
        .refreshable(action: {
            Task { await loadQuizzes() }
        })
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive, action: signOut)
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
        
    private var signOutButton: some View {
        Button(action: {
            showingSignOutAlert = true
        }) {
            Text("Sign Out")
                .font(theme.fonts.small)
                .padding(8)
                .foregroundColor(theme.colors.accent)
                .background(theme.colors.primary)
                .cornerRadius(4)
        }
    }
    
    private func loadQuizzes() async {
        profileVM.user = userManager.user
        await profileVM.getQuizzes()
    }
    
    private func signOut() {
        // Implement your sign-out logic here
        // For example:
        // userManager.signOut()
        userManager.signOut(completion: { err in })
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserManager())
            .environmentObject(Theme.theme1) // Use your default theme here
            .colorScheme(.dark)
    }
}
