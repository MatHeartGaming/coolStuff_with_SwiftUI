//
//  Network_ObserverApp.swift
//  Network Observer
//
//  Created by Matteo Buompastore on 18/04/25.
//

import SwiftUI

@main
struct Network_ObserverApp: App {
    
    @StateObject private var networkObserver = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.isNetworkConnected, networkObserver.isConnected)
                .environment(\.connectionType, networkObserver.connectionType)
        }
    }
}
