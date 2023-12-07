//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        /// Setting up the Container
        .modelContainer(for: [Expense.self, Category.self])
    }
}
