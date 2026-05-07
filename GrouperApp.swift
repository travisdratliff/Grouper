//
//  GrouperApp.swift
//  Grouper
//
//  Created by Travis Domenic Ratliff on 5/4/26.
//

import SwiftUI
import SwiftData

@main
struct GrouperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Organization.self, Member.self, Guardian.self, Message.self])
    }
}
