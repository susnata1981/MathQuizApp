//
//  MathQuizApp.swift
//  MathQuiz
//
//  Created by Susnata Basak on 8/30/24.
//

import SwiftUI

import FirebaseAnalytics
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

      FirebaseApp.configure()
      return true
  }
}

@main
struct MathQuizApp: App {
    @StateObject var session = Session()
    @StateObject var userManager = UserManager()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            StartView()
                .onAppear() {
                    userManager.listenForStateChange()
                }
        }
        .environmentObject(userManager)
        .environmentObject(session)
    }
}
