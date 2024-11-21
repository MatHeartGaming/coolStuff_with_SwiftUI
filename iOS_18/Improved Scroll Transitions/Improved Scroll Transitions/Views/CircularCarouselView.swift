//
//  CircularCarouselView.swift
//  Improved Scroll Transitions
//
//  Created by Matteo Buompastore on 21/11/24.
//

import SwiftUI

struct CircularCarouselView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(images) { image in
                        Image(image.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 220, height: size.height)
                            .clipShape(.rect(cornerRadius: 25))
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .blur(radius: phase == .identity ? 0 : 2, opaque: false)
                                    .scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
                                /// Add this for ciruclar effecr
                                    .offset(y: phase == .identity ? 0 : 25)
                                    .rotationEffect(.degrees(phase == .identity ? 0 : phase.value * 15), anchor: .bottom)
                            }
                    }
                } //: Lazy HSTACK
                .scrollTargetLayout()
            } //: V-SCROLL
            /// Makes the ScrollView have "No Bounds"
            .scrollClipDisabled()
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.horizontal, (size.width - 220) / 2)
        } //: Geometry
        .frame(height: 330)
    }
}

#Preview {
    CircularCarouselView()
}
