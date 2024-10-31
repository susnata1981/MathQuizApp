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
            theme.colors.background.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                HistoryView(quizzes: profileVM.quizzes)
                    .frame(maxHeight: .infinity)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                signOutButton
            }
        }
        .onAppear(perform: {
            Task { await loadQuizzes() }
        })
        .toolbarBackground(theme.colors.background, for: .tabBar)
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
                .foregroundColor(theme.colors.background)
                .background(theme.colors.accent)
                .cornerRadius(4)
        }
    }
    
    private func loadQuizzes() async {
        profileVM.user = userManager.user
        await profileVM.getQuizzes()
    }
    
    private func signOut() {
        userManager.signOut(completion: { err in })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserManager())
            .environmentObject(Theme.theme4)
            .colorScheme(.light)
    }
}

//import SwiftUI
//
//struct ProfileView: View {
//    @EnvironmentObject var userManager: UserManager
//    @EnvironmentObject var theme: Theme
//    @State var profileVM = ProfileViewModel()
//    @State private var showingSignOutAlert = false
//    
//    var body: some View {
//        ZStack {
//            theme.colors.background.edgesIgnoringSafeArea(.all)
//            
//            VStack(spacing: 0) {
//                HistoryView(quizzes: profileVM.quizzes)
//                    .frame(maxHeight: .infinity)
//                
//                // This ZStack will create the background for the tab bar
//                ZStack {
////                    theme.colors.primary.opacity(0.4)
////                        .edgesIgnoringSafeArea(.bottom)
////                        .frame(height: 14)
//                    
//                    Color.gray.opacity(0.4)
//                        .edgesIgnoringSafeArea(.bottom)
//                        .frame(height: 14)
//                }
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                signOutButton
//            }
//        }
//        .onAppear(perform: {
//            Task { await loadQuizzes() }
//        })
//        .refreshable(action: {
//            Task { await loadQuizzes() }
//        })
//        .alert("Sign Out", isPresented: $showingSignOutAlert) {
//            Button("Cancel", role: .cancel) { }
//            Button("Sign Out", role: .destructive, action: signOut)
//        } message: {
//            Text("Are you sure you want to sign out?")
//        }
//    }
//    
//    private var signOutButton: some View {
//        Button(action: {
//            showingSignOutAlert = true
//        }) {
//            Text("Sign Out")
//                .font(theme.fonts.small)
//                .padding(8)
//                .foregroundColor(theme.colors.background)
//                .background(theme.colors.primary)
//                .cornerRadius(4)
//        }
//    }
//    
//    private func loadQuizzes() async {
//        profileVM.user = userManager.user
//        await profileVM.getQuizzes()
//    }
//    
//    private func signOut() {
//        // Implement your sign-out logic here
//        // For example:
//        // userManager.signOut()
//        userManager.signOut(completion: { err in })
//    }
//}
//
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//            .environmentObject(UserManager())
//            .environmentObject(Theme.theme1) // Use your default theme here
//            .colorScheme(.dark)
//    }
//}
