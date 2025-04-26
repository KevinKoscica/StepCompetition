//
//  StepCompetitionApp.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/10/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct StepCompetitionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
