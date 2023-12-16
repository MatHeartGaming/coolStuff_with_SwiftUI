//
//  Settings.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - UI
    @AppStorage("userName") private var username = ""
    /// App Lock
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled = false
    @AppStorage("lockWhenAppGoesBackground") private var lockOnBackground = false
    
    /// App Theme
    @AppStorage("theme") private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationStack {
            
            List {
                
                Section("Username") {
                    TextField("Username", text: $username)
                } //: SECTION USERNAME
                
                Section("App Lock") {
                    
                    Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("Lock when app goes in background", isOn: $lockOnBackground)
                    }
                }
                
                Section("App Theme") {
                    
                    Toggle("Dark Mode Enabled", isOn: $isDarkMode)
                    
                }
                
            } //: LIST
            .navigationTitle("Settings")
            
        } //: NAVIGATION
    }
}

#Preview {
    SettingsView()
}
