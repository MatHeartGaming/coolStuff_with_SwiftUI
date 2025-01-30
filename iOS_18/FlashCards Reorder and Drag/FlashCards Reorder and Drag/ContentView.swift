//
//  ContentView.swift
//  FlashCards Reorder and Drag
//
//  Created by Matteo Buompastore on 28/01/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject private var dragProperties = DragProperties()
    
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Flash Cards")
                .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
        .overlay(alignment: .topLeading) {
            if let previewImage = dragProperties.previewImage,
                dragProperties.show {
                Image(uiImage: previewImage)
                    .opacity(0.8)
                    .offset(x: dragProperties.initalViewLocation.x,
                            y: dragProperties.initalViewLocation.y)
                    .offset(dragProperties.offset)
                    .ignoresSafeArea()
            }
        }
        .environmentObject(dragProperties)
    }
    
}

#Preview {
    ContentView()
}
