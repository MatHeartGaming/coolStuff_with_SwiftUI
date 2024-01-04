//
//  ContentView.swift
//  YouTube Video Player
//
//  Created by Matteo Buompastore on 04/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            Home(size: size, safeArea: safeArea)
        } //: GEOMETRY
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
