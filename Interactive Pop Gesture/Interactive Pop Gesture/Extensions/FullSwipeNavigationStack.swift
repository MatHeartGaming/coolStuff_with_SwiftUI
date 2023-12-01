//
//  FullSwipeNavigationStack.swift
//  Interactive Pop Gesture
//
//  Created by Matteo Buompastore on 16/11/23.
//

import SwiftUI

struct FullSwipeNavigationStack<Content: View>: View {
    
    //MARK: - PROPERTIES
    @ViewBuilder var content: Content
    @State private var customGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = UUID().uuidString
        gesture.isEnabled = true
        return gesture
    }()
    
    var body: some View {
        NavigationStack {
            content
                .background {
                    AttachGestureView(gesture: $customGesture)
                }
            
        }
        .environment(\.popGestureID, customGesture.name)
        .onReceive(NotificationCenter.default.publisher(for: .init(customGesture.name ?? "")), perform: { info in
            if let userInfo = info.userInfo, let status = userInfo["status"] as? Bool {
                customGesture.isEnabled = status
            }
        })
    }
}

/// Custom Environment key for passing Gesture ID to its subviews
fileprivate struct PopNotificationID: EnvironmentKey {
    static var defaultValue: String?
}

extension EnvironmentValues {
    var popGestureID: String? {
        get {
            self[PopNotificationID.self]
        }
        set {
            self[PopNotificationID.self] = newValue
        }
    }
}

extension View {
    
    @ViewBuilder
    func enableFullSwipePop(_ isEnabled: Bool) -> some View {
        self.modifier(FullSwipeModifier(isEnabled: isEnabled))
    }
    
}

fileprivate struct FullSwipeModifier: ViewModifier {
    var isEnabled: Bool
    @Environment(\.popGestureID) private var gestureID
    func body(content: Content) -> some View {
        content
            .onChange(of: isEnabled, initial: true) { oldValue, newValue in
                guard let gestureID else {return}
                NotificationCenter.default.post(
                    name: .init(gestureID), object: nil,
                    userInfo: [
                        "status": newValue
                    ]
                )
            }
            .onDisappear {
                guard let gestureID else {return}
                NotificationCenter.default.post(
                    name: .init(gestureID), object: nil,
                    userInfo: [
                        "status": false
                    ]
                )
            }
    }
}

#Preview {
    ContentView()
}
