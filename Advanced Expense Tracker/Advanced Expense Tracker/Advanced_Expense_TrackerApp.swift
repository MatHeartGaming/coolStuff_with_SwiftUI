//
//  Advanced_Expense_TrackerApp.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 11/12/23.
//

import SwiftUI

@main
struct Advanced_Expense_TrackerApp: App {
    
    /// App Theme
    @AppStorage("theme") private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .animation(.easeIn, value: isDarkMode)
        }
        .modelContainer(for: [Transaction.self])
    }
}
