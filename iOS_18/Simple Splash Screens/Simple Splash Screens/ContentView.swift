//
//  ContentView.swift
//  Simple Splash Screens
//
//  Created by Matteo Buompastore on 18/09/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var showsSplashScreen: Bool = true
    
    var body: some View {
        ZStack {
            if showsSplashScreen {
                SplashScreen()
                    .transition(CustomSplashTransition3D(isRoot: false))
            } else {
                RootView()
                    .transition(CustomSplashTransition3D(isRoot: true))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
        .task {
            guard showsSplashScreen else { return }
            try? await Task.sleep(for: .seconds(0.5))
            withAnimation(.smooth(duration: 0.55), completionCriteria: .logicallyComplete) {
                showsSplashScreen = false
            } completion: {
                /// Place sheets or other Views openings here...
            }
        }
    }
    
    var safeAre: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    
}

struct CustomSplashTransition: Transition {
    
    var isRoot: Bool
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .offset(y: phase.isIdentity ? 0 : (isRoot ? screenSize.height : -screenSize.height))
    }
    
    /// Current Screen size (without usage of GeometryReader
    var screenSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        return .zero
    }
    
}

struct CustomSplashTransition3D: Transition {
    
    var isRoot: Bool
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
        /// Commenting this line will result in a horizontal slide effect
            .rotation3DEffect(.degrees(phase.isIdentity ? 0 : isRoot ? 70 : -70),
                              axis: (x: 0, y: 1, z: 0),
                              anchor: isRoot ? .leading : .trailing)
            .offset(x: phase.isIdentity ? 0 : (isRoot ? screenSize.width : -screenSize.width))
    }
    
    /// Current Screen size (without usage of GeometryReader
    var screenSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        return .zero
    }
    
}

struct SplashScreen: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.splashBackground)
            Image("Logo Icon")
            
        }
        .ignoresSafeArea()
    }
    
}

struct RootView: View {
    
    var body: some View {
        TabView {
            Tab.init("Home", systemImage: "house") {
                Text("Home")
            }
            Tab.init("Search", systemImage: "magnifyingglass") {
                Text("Search")
            }
            Tab.init("Settings", systemImage: "gearshape") {
                Text("Settings")
            }
        }
    }
    
}

#Preview {
    ContentView()
}
