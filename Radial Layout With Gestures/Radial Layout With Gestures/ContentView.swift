//
//  ContentView.swift
//  Radial Layout With Gestures
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Radial Layout")
        }
    }
}

#Preview {
    ContentView()
}
