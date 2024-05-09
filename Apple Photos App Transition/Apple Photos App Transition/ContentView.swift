//
//  ContentView.swift
//  Apple Photos App Transition
//
//  Created by Matteo Buompastore on 09/05/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    var coordinator: UICoordinator = .init()
    
    var body: some View {
        NavigationStack {
            Home()
                .environment(coordinator)
        } //: NAVIGATION
        .overlay {
            if coordinator.selectedItem != nil {
                Detail()
                    .environment(coordinator)
                    .allowsHitTesting(coordinator.showDetailView)
            }
        }
        .overlayPreferenceValue(HeroKey.self, { value in
            if let selectedItem = coordinator.selectedItem,
               let sAnchor = value[selectedItem.id + "SOURCE"],
               let dAnchor = value[selectedItem.id + "DEST"] {
                HeroLayer()
            }
        })
    }
}

#Preview {
    ContentView()
        .environment(UICoordinator())
}
