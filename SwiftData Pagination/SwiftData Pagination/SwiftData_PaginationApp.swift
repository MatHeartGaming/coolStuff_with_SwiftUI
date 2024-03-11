//
//  SwiftData_PaginationApp.swift
//  SwiftData Pagination
//
//  Created by Matteo Buompastore on 11/03/24.
//

import SwiftData
import SwiftUI

@main
struct SwiftData_PaginationApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Country.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        SampleData.loadData()
        
        do {
            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            return modelContainer
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Country.self])
    }
}
