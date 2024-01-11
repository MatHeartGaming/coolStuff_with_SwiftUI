//
//  DeepLinksAppApp.swift
//  DeepLinksApp
//
//  Created by Matteo Buompastore on 11/01/24.
//

import SwiftUI

@main
struct DeepLinksAppApp: App {
    
    // mbdeeplinkapp://tab=settings
    // mbdeeplinkapp://tab=settings?nav=terms_of_service
    
    // MARK: - UI
    @StateObject private var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
                /// Called when deep link gets triggered
                .onOpenURL { url in
                    let string = url.absoluteString.replacingOccurrences(of: "mbdeeplinkapp://", with: "")
                    print("Deep Link: \(string)")
                    let components = string.components(separatedBy: "?")
                    
                    /// Splitting URL Component's
                    for component in components {
                        
                        if component.contains("tab=") {
                            /// Tab change request
                            let tabRawValue = component.replacingOccurrences(of: "tab=", with: "")
                            print("Tab Row: \(tabRawValue)")
                            if let requestedTab = Tab.convert(from: tabRawValue) {
                                appData.activeTab = requestedTab
                            }
                        }
                        
                        if component.contains("nav=") && string.contains("tab") {
                            /// Nav change request
                            let requestedNavPath = component
                                .replacingOccurrences(of: "nav=", with: "")
                                .replacingOccurrences(of: "_", with: " ")
                            print("Nav path: \(requestedNavPath)")
                            
                            switch appData.activeTab {
                            case .home:
                                if let navPath = HomeStack.convert(from: requestedNavPath) {
                                    appData.homeNavStack.append(navPath)
                                }
                            case .favourite:
                                if let navPath = FavoriteStack.convert(from: requestedNavPath) {
                                    appData.favoriteNavStack.append(navPath)
                                }
                            case .settings:
                                if let navPath = SettingsStack.convert(from: requestedNavPath) {
                                    appData.settingsNavStack.append(navPath)
                                }
                            }
                        }
                        
                    }
                    
                }
        }
    }
}
