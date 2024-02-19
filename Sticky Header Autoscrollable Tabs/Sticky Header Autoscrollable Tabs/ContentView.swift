//
//  ContentView.swift
//  Sticky Header Autoscrollable Tabs
//
//  Created by Matteo Buompastore on 19/02/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
        } //: NAVIGATION
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
