//
//  ContentView.swift
//  Flight App Animation
//
//  Created by Matteo Buompastore on 15/02/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .vertical)
        }
    }
}

#Preview {
    ContentView()
}
