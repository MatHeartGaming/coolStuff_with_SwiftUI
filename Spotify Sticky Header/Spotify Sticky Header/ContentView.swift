//
//  ContentView.swift
//  Spotify Sticky Header
//
//  Created by Matteo Buompastore on 24/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            let size = proxy.size
            
            Home(safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: [.top])
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
