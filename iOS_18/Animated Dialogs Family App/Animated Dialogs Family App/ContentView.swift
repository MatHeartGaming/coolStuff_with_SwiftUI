//
//  ContentView.swift
//  Animated Dialogs Family App
//
//  Created by Matteo Buompastore on 06/05/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var config: DrawerConfig = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                DrawerButton(title: "Continue", config: $config)
                
            } //: VSTACK
            .padding(15)
            .navigationTitle("Alert Drawer")
        } //: NAVIGATION
        .alertDrawer(config: $config,
                     primaryTitle: "Continue",
                     secondaryTitle: "Cancel") {
            return false
        } onSecondaryClick: {
            return true
        } content: {
            /// Dummy content
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "exclamationmark.circle")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Are you sure?")
                    .font(.title2.bold())
                
                Text("You haven't backed up your wallet yet.\nIf you remove it, you could lose access forever. We suggest tapping Cancel and backing up your wallet first with a valid recovery method.")
                    .foregroundStyle(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 300)
            } //: VSTACK
        }
    }
}

#Preview {
    ContentView()
}
