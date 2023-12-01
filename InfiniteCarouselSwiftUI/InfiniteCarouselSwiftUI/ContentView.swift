//
//  ContentView.swift
//  InfiniteCarouselSwiftUI
//
//  Created by Matteo Buompastore on 30/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Looping ScrollView")
        }
    }
}

#Preview {
    ContentView()
}
