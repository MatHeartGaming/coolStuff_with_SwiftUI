//
//  ContentView.swift
//  Reorderable Scroll Grid
//
//  Created by Matteo Buompastore on 19/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            
            Image(.wallpaper)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .scaleEffect(1.05)
                .blur(radius: 40, opaque: true)
                .overlay {
                    Rectangle()
                        .fill(.black.opacity(0.15))
                }
                .ignoresSafeArea()
            
            Home(safeArea: safeArea)
        }
    }
}

#Preview {
    ContentView()
}
