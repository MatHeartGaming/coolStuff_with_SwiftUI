//
//  ContentView.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 11/12/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - UI
    
    /// Intro
    @AppStorage("isFirstTime") private var isFirstTime = true
    
    /// Active Tab
    @State private var activeTab: Tab = .recents
    
    var body: some View {
        TabView(selection: $activeTab) {
            
            Text("Recents")
                .tag(Tab.recents)
                .tabItem {
                    Tab.recents.tabContent
                }
            
            Text("Search")
                .tag(Tab.search)
                .tabItem {
                    Tab.search.tabContent
                }
            
            Text("Charts")
                .tag(Tab.charts)
                .tabItem {
                    Tab.charts.tabContent
                }
            
            Text("Settings")
                .tag(Tab.settings)
                .tabItem {
                    Tab.settings.tabContent
                }
            
            
        } //: TABVIEW
        .tint(appTint)
        .sheet(isPresented: $isFirstTime, content: {
            IntroScreen()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    ContentView()
}
