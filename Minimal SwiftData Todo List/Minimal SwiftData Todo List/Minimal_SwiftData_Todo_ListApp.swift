//
//  Minimal_SwiftData_Todo_ListApp.swift
//  Minimal SwiftData Todo List
//
//  Created by Matteo Buompastore on 01/02/24.
//

import SwiftUI
import SwiftData

@main
struct Minimal_SwiftData_Todo_ListApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Todo.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
    
}
