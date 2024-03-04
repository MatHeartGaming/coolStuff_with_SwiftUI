//
//  Minimal_Login_Setup_FirebaseApp.swift
//  Minimal Login Setup Firebase
//
//  Created by Matteo Buompastore on 04/03/24.
//

import SwiftUI
import Firebase

@main
struct Minimal_Login_Setup_FirebaseApp: App {
    
    /// In case the app needs Notfications and other features use the UIApplicationDelegateAdaptor instead.
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
