//
//  ContentView.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - UI
    @State private var showSignup = false
    /// Keyboard status
    @State private var isKeyboardShowing = false
    
    var body: some View {
        NavigationStack {
            Login(showSignup: $showSignup)
                .navigationDestination(isPresented: $showSignup) {
                    Signup(showSignup: $showSignup)
                }
            /// Checking if any keybord is active
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                    if !showSignup {
                        isKeyboardShowing = true
                    }
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                    isKeyboardShowing = false
                })
        } //: NAVGATION
        .overlay {
            if #available(iOS 17, *) {
                CircleView()
                    .animation(.smooth(duration: 0.5, extraBounce: 0), value: showSignup)
                    .animation(.smooth(duration: 0.5, extraBounce: 0), value: isKeyboardShowing)
            } else {
                CircleView()
                    .animation(.easeInOut(duration: 0.5), value: showSignup)
                    .animation(.smooth(duration: 0.5, extraBounce: 0), value: isKeyboardShowing)
            }
            
        }
    }
    
    /// Moving blurred background
    @ViewBuilder
    func CircleView() -> some View {
        Circle()
            .fill(.linearGradient(colors: [.appYellow, .orange, .red], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200)
            .offset(x: showSignup ? 90 : -90, y: -90 - (isKeyboardShowing ? 200 : 0))
            .blur(radius: 15)
            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
    }
    
}

#Preview {
    ContentView()
}
