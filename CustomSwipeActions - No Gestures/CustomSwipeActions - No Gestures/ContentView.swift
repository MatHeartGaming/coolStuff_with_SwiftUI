//
//  ContentView.swift
//  CustomSwipeActions - No Gestures
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Messages")
        }
    }
}

#Preview {
    ContentView()
}
