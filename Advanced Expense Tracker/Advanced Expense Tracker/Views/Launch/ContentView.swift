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
    
    /// Lock View
    /// App Lock
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled = false
    @AppStorage("lockWhenAppGoesBackground") private var lockOnBackground = false
    
    /// Active Tab
    @State private var activeTab: Tab = .recents
    
    var body: some View {
        LockView(lockType: .biometric, lockPin: "", 
                 isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockOnBackground) {
            
            TabView(selection: $activeTab) {
                
                Recents()
                    .tag(Tab.recents)
                    .tabItem {
                        Tab.recents.tabContent
                    }
                
                Search()
                    .tag(Tab.search)
                    .tabItem {
                        Tab.search.tabContent
                    }
                
                Graphs()
                    .tag(Tab.charts)
                    .tabItem {
                        Tab.charts.tabContent
                    }
                
                SettingsView()
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
        } //: LOCK VIEW
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Transaction.self])
}
