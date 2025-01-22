//
//  Notificaton_Deep_LinkingApp.swift
//  Notificaton Deep Linking
//
//  Created by Matteo Buompastore on 22/01/25.
//

import SwiftUI

@main
struct Notificaton_Deep_LinkingApp: App {
    
    @UIApplicationDelegateAdaptor(AppData.self) private var appData
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appData)
                .onOpenURL { url in
                    if let pageName = url.host {
                        print(pageName)
                        appData.mainPageNavigationPath.append(pageName)
                    }
                }
        }
    }
}

@Observable
class AppData: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var mainPageNavigationPath: [String] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        /// Showing alert even when app is active
        return [.sound, .banner]
    }
    
    /// Handling Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(response.notification.request.content.userInfo)
        if let pageLink = response.notification.request.content.userInfo["pageLink"] as? String {
            /*if mainPageNavigationPath.last != pageLink {
                /// Optional: Remove previous pages
                mainPageNavigationPath = []
                /// Push new page
                mainPageNavigationPath.append(pageLink)
            }*/
            
            /// For deep linking
            guard let url = URL(string: pageLink) else { return }
            UIApplication.shared.open(url, options: [:]) { _ in
                
            }
        }
    }
    
}
