//
//  ContentView.swift
//  ParticleEffect
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Particle FX")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
