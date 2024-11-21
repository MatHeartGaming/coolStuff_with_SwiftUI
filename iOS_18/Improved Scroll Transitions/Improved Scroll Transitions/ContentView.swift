//
//  ContentView.swift
//  Improved Scroll Transitions
//
//  Created by Matteo Buompastore on 21/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(images) { image in
                        let _ = print("Image \(image.image)")
                        Image(image.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 220, height: size.height)
                            .clipShape(.rect(cornerRadius: 25))
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .blur(radius: phase == .identity ? 0 : 2, opaque: false)
                                    .scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
                            }
                    }
                } //: Lazy HSTACK
                .scrollTargetLayout()
            } //: V-SCROLL
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.horizontal, (size.width - 220) / 2)
        } //: Geometry
        .frame(height: 330)
    }
}

struct Images: Identifiable {
    let id: String = UUID().uuidString
    var image: String
    var link: String
}

var images: [Images] = (1...9).map({
    .init(
        image: "Pic\($0)",
        link: "")
})

#Preview {
    ContentView()
}
