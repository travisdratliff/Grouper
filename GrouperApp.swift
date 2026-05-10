//
//  GrouperApp.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/4/26.
//

import SwiftUI
import SwiftData
import FirebaseCore
import UIKit
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // request push notification permission
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        return true
    }
}

@main
struct GrouperApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var showSplash = true
    @State var isLoggedIn = false
    @State var userRole = ""
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreen()
                        .transition(.opacity)
                } else {
//                    if isLoggedIn {
//                        ContentView()
//                    } else {
//                        LoginView(isLoggedIn: $isLoggedIn)
//                            .transition(.opacity)
//                    }
                    if !isLoggedIn {
                                    LoginView(isLoggedIn: $isLoggedIn, userRole: $userRole)
                                } else if userRole.isEmpty {
                                    RolePickerView(isLoggedIn: $isLoggedIn, userRole: $userRole)
                                } else if userRole == "coach" {
                                    ContentView()
                                } else {
                                    MemberView()
                                }
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showSplash)
            .onAppear {
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    self.showSplash = false
                }
            }
        }
        .modelContainer(for: [Organization.self, Member.self, Guardian.self, Message.self])
    }
}
