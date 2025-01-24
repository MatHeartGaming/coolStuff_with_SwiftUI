//
//  ContentView.swift
//  Stacked Loopinig Cards
//
//  Created by Matteo Buompastore on 24/01/25.
//

import SwiftUI

/// Sample Images
struct ImageModel: Identifiable {
    let id: String = UUID().uuidString
    var altText: String
    var image: String
}

let images: [ImageModel] = [
    .init(altText: "Image 1", image: "Pic 1"),
    .init(altText: "Image 2", image: "Pic 2"),
    .init(altText: "Image 3", image: "Pic 3"),
    .init(altText: "Image 4", image: "Pic 4"),
    .init(altText: "Image 5", image: "Pic 5"),
    .init(altText: "Image 6", image: "Pic 6"),
    .init(altText: "Image 7", image: "Pic 7"),
]

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                /// You can use a GeometryReader to avoid over-dragging
                GeometryReader { proxy in
                    let width = proxy.size.width
                    LoopingStack(maxTranslationWidth: width) {
                        ForEach(images) { image in
                            Image(image.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 400)
                                .clipShape(.rect(cornerRadius: 30))
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 35)
                                        .fill(.background)
                                    
                                }
                        } //: Loop Images
                    } //: Looping Cards
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } //: GEOMETRY
                .frame(height: 420)
            } //: VSTACK
            .navigationTitle("Looping Stack")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.2))
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
