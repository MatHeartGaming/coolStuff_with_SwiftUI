//
//  ContentView.swift
//  Trip Planner (ScrollTransition APIs)
//
//  Created by Matteo Buompastore on 08/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollTransition()
                .navigationTitle("Trip Planner")
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
