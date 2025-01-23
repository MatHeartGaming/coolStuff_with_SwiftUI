//
//  MacOS_Screen_Recording_AppApp.swift
//  MacOS Screen Recording App
//
//  Created by Matteo Buompastore on 22/01/25.
//

import SwiftUI

@main
struct MacOS_Screen_Recording_AppApp: App {
    
    // MARK: Properties
    @AppStorage("isUserIntroCompleted") private var isUserIntroCompleted: Bool = false
    
    @State private var introScreenShowed: Bool = false
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        /// Only Adding menu bar after the intro is completed
        MenuBarExtra("Mac Recorder", systemImage: "inset.filled.rectangle.badge.record", isInserted: .constant(isUserIntroCompleted)) {
            MenuView()
        }
        .menuBarExtraStyle(.window)
        .onChange(of: scenePhase, initial: true) { oldValue, newValue in
            if !isUserIntroCompleted && !introScreenShowed {
                openWindow(id: "IntroView")
                introScreenShowed = true
            }
        }
        
        WindowGroup(id: "IntroView") {
            IntroView()
        }
        .windowLevel(.floating)
        .windowStyle(.plain)
        .restorationBehavior(.disabled)
        /// Place at center screen
        .defaultWindowPlacement { content, context in
            let displaySize = context.defaultDisplay.visibleRect.size
            let size = content.sizeThatFits(.init(displaySize))
            
            return .init(.center, size: size)
        }
    }
}
