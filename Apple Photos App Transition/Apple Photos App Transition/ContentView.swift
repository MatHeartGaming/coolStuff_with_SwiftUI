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
                .allowsHitTesting(coordinator.selectedItem == nil)
        } //: NAVIGATION
        .overlay {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
                .opacity(coordinator.animateView ? 1 : 0)
        }
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
                HeroLayer(
                    item: selectedItem,
                    sAnchor: sAnchor,
                    dAnchor: dAnchor
                )
                .environment(coordinator)
            }
        })
    }
}

#Preview {
    ContentView()
        .environment(UICoordinator())
}
