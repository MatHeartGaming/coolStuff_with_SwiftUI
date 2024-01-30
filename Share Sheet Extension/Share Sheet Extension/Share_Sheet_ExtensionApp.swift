//
//  Share_Sheet_ExtensionApp.swift
//  Share Sheet Extension
//
//  Created by Matteo Buompastore on 30/01/24.
//

import SwiftUI

@main
struct Share_Sheet_ExtensionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ImageItem.self)
        }
    }
}
