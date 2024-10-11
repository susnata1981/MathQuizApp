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
            
            VStack {
                headerView
                quizListView
            }
        }
        .navigationTitle("Quiz History")
        .navigationBarTitleDisplayMode(.inline)
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
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Text(userManager.user?.name ?? "User")
                .font(theme.fonts.large)
                .foregroundColor(theme.colors.primary)
            
            Text(userManager.user?.email ?? "")
                .font(theme.fonts.regular)
                .foregroundColor(theme.colors.secondary)
        }
        .padding()
    }
    
    private var quizListView: some View {
        List {
            ForEach(profileVM.quizzes, id: \.id) { quiz in
                NavigationLink(value: Destination.reviewResult(quiz: quiz)) {
                    QuizRowView(quiz: quiz)
                }
            }
        }
        .listStyle(PlainListStyle())
        .background(theme.colors.background)
    }
    
    private var signOutButton: some View {
        Button(action: {
            showingSignOutAlert = true
        }) {
            Text("Sign Out")
                .foregroundColor(theme.colors.error)
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

struct QuizRowView: View {
    @EnvironmentObject var theme: Theme
    let quiz: Quiz
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(quiz.getCreatedAtDate())
                    .font(theme.fonts.small)
                    .foregroundColor(theme.colors.secondary)
                
                Text("Status: \(quiz.status.rawValue)")
                    .font(theme.fonts.regular)
                    .foregroundColor(theme.colors.text)
            }
            
            Spacer()
            
            Text("Score: \(quiz.getPercentageScore)%")
                .font(theme.fonts.bold)
                .foregroundColor(scoreColor)
        }
        .padding(.vertical, 8)
    }
    
    private var scoreColor: Color {
        let score = quiz.getPercentageScore
        if score >= 80 {
            return theme.colors.success
        } else if score >= 60 {
            return theme.colors.error
        } else {
            return theme.colors.error
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserManager())
            .environmentObject(Theme.theme1) // Use your default theme here
    }
}
