////
////  StartQuiz.swift
////  MathQuiz
////
////  Created by Susnata Basak on 8/31/24.
////
//


import SwiftUI
import UIKit

struct StartQuizView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var session: Session
    @EnvironmentObject var theme: Theme
    
    @State private var viewModel = StartQuizViewModel()
    @State private var showCountdown = false
    
    @EnvironmentObject var quizNavManager: NavigationManager
    @EnvironmentObject var profileNavManager: NavigationManager
    
    var body: some View {
        ZStack {
            theme.colors.background.ignoresSafeArea(.all)

            mainContent
                .onAppear{
                    setupSession()
                    customizeSegmentedControl()
                }
                .accentColor(theme.colors.accent)
        }
    }
  
    private var mainContent: some View {
        ScrollView {
            VStack {
                ZStack {
                    if showCountdown {
                        MyCountDownView(showCountdown: $showCountdown) {
                            Task {
                                print("Animation finished, waiting for quiz handler")
                                session.quiz = await viewModel.handleStartQuiz()
                                showCountdown = false
                                quizNavManager.gotoQuiz()
                            }
                        }
                        .transition(.opacity)
                    }
                    
                    VStack(spacing: 30) {
                        titleView
                        ChooseGameType(viewModel: viewModel)
                        DifficultyPicker(viewModel: viewModel)
                        NumberOfProblemsPicker(viewModel: viewModel)
                        startButton
                    }.padding()
                }
            }.padding(.bottom, 16)
        }.navigationBarBackButtonHidden()
    }
    
    private var titleView: some View {
        VStack {
            Text("Math Quiz")
                .font(theme.fonts.large)
                .foregroundColor(theme.colors.text)
                .padding()
        }
    }
    
    struct NumberOfProblemsPicker: View {
        @State var viewModel: StartQuizViewModel
        @EnvironmentObject var theme: Theme
        
        let problemOptions = [5, 10, 15, 20]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Number of Problems")
                    .font(theme.fonts.bold)
                    .foregroundColor(theme.colors.text)
                
                Picker("Select Number of Problems", selection: $viewModel.numberOfProblems) {
                    ForEach(problemOptions, id: \.self) { number in
                        Text("\(number)")
                            .tag(number)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .cornerRadius(12)
        }
    }
    
    private var startButton: some View {
        StandardButton(title: "Start", action: {
            if viewModel.validate() {
                showCountdown = true
            }
        })
        .alert("Choose operation", isPresented: $viewModel.hasError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select an operation before starting the quiz.")
        }
    }
    
    private var signOutButton: some View {
        Button(action: {
            userManager.signOut(completion: { err in
                print("Failed to sign out \(String(describing: err?.localizedDescription))")
            })
        }) {
            Text("\(userManager.user?.name ?? "") Sign Out")
                .font(theme.fonts.regular)
                .foregroundColor(theme.colors.text)
                .padding(8)
                .background(theme.colors.accent.opacity(0.8))
                .cornerRadius(8)
        }
        .opacity(userManager.isUserLoggedIn() ? 1 : 0)
    }
    
    private func setupSession() {
        session.user = userManager.user
        viewModel.user = userManager.user
    }
    
    private func customizeSegmentedControl() {
        // Tint color
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(theme.colors.primary)
        // Background color
        UISegmentedControl.appearance().backgroundColor = UIColor(theme.colors.background.opacity(0.1))

        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(theme.colors.accent)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.white)], for: .selected)
    }
}

struct ChooseGameType: View {
    @State var viewModel: StartQuizViewModel
    @EnvironmentObject var theme: Theme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Choose Operation")
                .font(theme.fonts.bold)
                .foregroundColor(theme.colors.text)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                ForEach(MathOperation.allCases, id: \.self) { operation in
                    GameTypeButton(operation: operation, viewModel: viewModel)
                }
            }
        }
        .padding()
    }
}

struct GameTypeButton: View {
    let operation: MathOperation
    @State var viewModel: StartQuizViewModel
    @EnvironmentObject var theme: Theme
    @State var selected = false
    @State var scale = 1.0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(.bouncy)) {
                viewModel.handleSelectOperation(operation)
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1)
                            .shadow(.drop(color:.black.opacity(0.7), radius: 3, x: 5, y: 5)))
                        .stroke(viewModel.selectedOperation == operation ? theme.colors.primary : Color.clear, lineWidth: 2)
                        .scaleEffect(viewModel.selectedOperation == operation ? 0.9 : 1.0)
                        .frame(width: 84, height: 84)

                VStack {
                    Spacer()
                    
                    Image(systemName: operation.symbol)
                        .font(theme.fonts.xlarge)
                        .padding(.top)
                    
                    Spacer()
                    
                    Text(operation.description)
                        .font(theme.fonts.small)
                        .padding(.bottom)
                }
                .foregroundColor(viewModel.selectedOperation == operation ? theme.colors.text : theme.colors.accent)
            }
            .frame(width: 100, height: 100)
        }
    }
}

struct DifficultyPicker: View {
    @State var viewModel: StartQuizViewModel
    @EnvironmentObject var theme: Theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Difficulty Level")
                .font(theme.fonts.bold)
                .foregroundColor(theme.colors.text)
            
            Picker("Select Difficulty", selection: $viewModel.selectedDiffilcultyLevel) {
                ForEach(DifficultyLevel.allCases, id: \.self) { level in
                    Text(level.rawValue.capitalized)
                        .tag(level)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
    }
}

struct StartQuizView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with default theme
            StartQuizView()
                .environmentObject(mockUserManager())
                .environmentObject(Session())
                .environmentObject(Theme.theme5)
                .previewDisplayName("Default Theme")
                        
            // Preview in dark mode
            StartQuizView()
                .environmentObject(mockUserManager())
                .environmentObject(Session())
                .environmentObject(Theme.theme1)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
        }
    }
    
    static func mockUserManager(isLoggedIn: Bool = false) -> UserManager {
        let userManager = UserManager()
        if isLoggedIn {
            userManager.user = User(username: "testuser", pin: "1234", name: "Test User")
        }
        return userManager
    }
}

// If you haven't defined Theme.theme2, you can add it here or in your Theme file
extension Theme {
    static let theme3 = Theme(
        colors: ThemeColors(
            primary: Color.init(hex: 0x228B22),
            secondary: Color.init(hex: 0x5C4033),
            background: Color.init(hex: 0xF5FFFA),
            text: Color.init(hex: 0x594A4E),
            accent: Color.init(hex: 0xFFD700),
            success: Color.green,
            error: Color.red,
            disabled: Color.gray.opacity(0.5),
            selected: Color.init(hex: 0xFFD275),
            button: Color.init(hex: 0xD1495B)
        ),
        fonts: ThemeFonts(
            small: Font.footnote,
            regular: Font.body,
            bold: Font.headline,
            large: Font.title,
            xlarge: Font.largeTitle,
            xxlarge: Font.largeTitle,
            caption: Font.caption
        )
    )
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
