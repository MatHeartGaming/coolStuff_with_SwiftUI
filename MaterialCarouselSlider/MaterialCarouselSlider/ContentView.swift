//
//  ContentView.swift
//  MaterialCarouselSlider
//
//  Created by Matteo Buompastore on 05/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Carousel")
        }
    }
}

#Preview {
    ContentView()
}
