//
//  Manual_View_Control_OrientationApp.swift
//  Manual View Control Orientation
//
//  Created by Matteo Buompastore on 25/01/25.
//

import SwiftUI

@main
struct Manual_View_Control_OrientationApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    /// Use portrait if you want to start using portrait
    static var orientation: UIInterfaceOrientationMask = .all
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return Self.orientation
    }
    
}
