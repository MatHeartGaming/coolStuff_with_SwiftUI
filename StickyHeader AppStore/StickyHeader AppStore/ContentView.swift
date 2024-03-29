//
//  ContentView.swift
//  StickyHeader AppStore
//
//  Created by Matteo Buompastore on 24/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            Home(size: size, safeAreaInsets: safeArea)
        }
    }
}

#Preview {
    ContentView()
}
