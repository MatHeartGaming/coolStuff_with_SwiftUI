//
//  ContentView.swift
//  Pop To Root on TabViewItem Pressed
//
//  Created by Matteo Buompastore on 13/02/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var activeTab: Tab = .home
    /// Navigation Path
    @State private var homeStack: NavigationPath = .init()
    @State private var settingsStack: NavigationPath = .init()
    @State private var tapCount: Int = .zero
    private let requestedTaps: Int = 2
    
    var body: some View {
        TabView(selection: tabSelection) {
            
            NavigationStack(path: $homeStack) {
                List {
                    NavigationLink("Detail", value: "Detail")
                } //: LIST
                .navigationTitle("Home")
                .navigationDestination(for: String.self) { value in
                    if value == "Detail" {
                        NavigationLink("More", value: "More")
                    }
                }
            } //: NAVIGATION
            .tag(Tab.home)
            .tabItem {
                Image(systemName: Tab.home.symbolImage)
                Text(Tab.home.rawValue)
            } //: Tab Item
                                 
            NavigationStack(path: $settingsStack) {
                List {
                    
                } //: LIST
                .navigationTitle("Settings")
            } //: NAVIGATION
            .tag(Tab.settings)
            .tabItem {
                Image(systemName: Tab.settings.symbolImage)
                Text(Tab.settings.rawValue)
            } //: Tab Item
            
            
        } //: TABVIEW
    }
    
    var tabSelection: Binding<Tab> {
        return .init {
            return activeTab
        } set: { newTab in
            if newTab == activeTab {
                /// Same tab clicked once again
                tapCount += 1
                if (tapCount == requestedTaps) {
                    switch newTab {
                        case .home: homeStack = .init()
                        case .settings: settingsStack = .init()
                    }
                    tapCount = .zero
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                tapCount = .zero
            }
            activeTab = newTab
        }

    }
    
}

#Preview {
    ContentView()
}
