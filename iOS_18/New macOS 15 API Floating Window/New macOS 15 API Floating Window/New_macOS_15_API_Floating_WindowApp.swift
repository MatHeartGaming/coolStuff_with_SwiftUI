//
//  New_macOS_15_API_Floating_WindowApp.swift
//  New macOS 15 API Floating Window
//
//  Created by Matteo Buompastore on 16/01/25.
//

import SwiftUI

@main
struct New_macOS_15_API_Floating_WindowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        WindowGroup(id: "FloatingWindow") {
            FloatingWindow()
                /// To allow dragging when no background is visible
                //.allowsHitTesting(false)
                /// Or this if the view has buttons and interactable stuff
                .simultaneousGesture(WindowDragGesture())
                .toolbarVisibility(.hidden, for: .windowToolbar)
                .containerBackground(.clear, for: .window)
        }
        .windowLevel(.floating)
        /// Make it draggable
        .windowBackgroundDragBehavior(.enabled)
        /// Avoid resizability
        .windowResizability(.contentSize)
        /// Borderless Window
        .windowStyle(.plain)
        
        WindowGroup(id: "AlertWindow") {
            AlertWindow()
                .allowsHitTesting(false)
                .toolbarVisibility(.hidden, for: .windowToolbar)
                .containerBackground(.clear, for: .window)
        }
        .windowLevel(.floating)
        .windowBackgroundDragBehavior(.disabled)
        /// Avoid resizability
        .windowResizability(.contentSize)
        /// Borderless Window
        .windowStyle(.plain)
        .restorationBehavior(.disabled)
        .defaultWindowPlacement { content, context in
            let viewSize = content.sizeThatFits(.init(context.defaultDisplay.visibleRect.size))
            return .init(.init(x: 0.5, y: 0.9), size: viewSize)
        }
    }
}
