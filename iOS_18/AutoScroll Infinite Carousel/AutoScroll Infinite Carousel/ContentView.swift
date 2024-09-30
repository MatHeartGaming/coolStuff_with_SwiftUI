//
//  ContentView.swift
//  AutoScroll Infinite Carousel
//
//  Created by Matteo Buompastore on 30/09/24.
//

import SwiftUI

/// Sample Model
struct Item: Identifiable {
    let id: String = UUID().uuidString
    var color: Color
}

var mockItems: [Item] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .purple),
    .init(color: .orange),
]

struct ContentView: View {
    
    @State private var activePage: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                CustomCarousel(activeIndex: $activePage) {
                    ForEach(mockItems) { item in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.color.gradient)
                            .padding(.horizontal, 15)
                    } //: Loop Items
                    
                } //: Carousel
                .frame(height: 220)
                
                /// Cusotm Indicator
                HStack(spacing: 5) {
                    ForEach(mockItems.indices, id: \.self) { index in
                        Circle()
                            .fill(activePage == index ? .primary : .secondary)
                            .frame(width: 8, height: 8)
                    }
                } //: HSTACK
                .animation(.snappy, value: activePage)
                
            } //: VSTACK
            .navigationTitle("Auto Scroll Carousel")
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
