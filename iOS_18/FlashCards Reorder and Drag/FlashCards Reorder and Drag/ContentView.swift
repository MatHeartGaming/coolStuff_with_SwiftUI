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
    }
    
}

#Preview {
    ContentView()
}
