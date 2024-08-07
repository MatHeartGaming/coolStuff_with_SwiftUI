//
//  ContentView.swift
//  CoverFlow Carousel
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var activeID: UUID?
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomCarousel(
                    config: .init(hasOpacity: true, 
                                  hasScale: true,
                                  cardWidth: 200,
                                  minimumCardWidth: 30
                                 ),
                    selection: $activeID,
                    data: images) { item in
                    Image(item.image)
                        .resizable()
                        .scaledToFill()
                }
                .frame(height: 180)
            }
            .navigationTitle("Cover Carousel")
        }
    }
}

#Preview {
    ContentView()
}
