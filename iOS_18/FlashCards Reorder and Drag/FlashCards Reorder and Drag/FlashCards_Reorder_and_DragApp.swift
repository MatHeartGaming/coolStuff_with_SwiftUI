//
//  FlashCards_Reorder_and_DragApp.swift
//  FlashCards Reorder and Drag
//
//  Created by Matteo Buompastore on 28/01/25.
//

import SwiftUI

@main
struct FlashCards_Reorder_and_DragApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
