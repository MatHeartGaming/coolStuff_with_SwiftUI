//
//  ParallaxCarouselView.swift
//  Improved Scroll Transitions
//
//  Created by Matteo Buompastore on 21/11/24.
//

import SwiftUI

struct ParallaxCarouselView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(images) { image in
                        Image(image.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 220 + 80)
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .offset(x: phase == .identity ? 0 : -phase.value * 80)
                            }
                            .frame(width: 220, height: size.height)
                            .clipShape(.rect(cornerRadius: 25))
                        
                    }
                } //: Lazy HSTACK
                .scrollTargetLayout()
            } //: V-SCROLL
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.horizontal, (size.width - 220) / 2)
            .scrollIndicators(.hidden)
        } //: Geometry
        .frame(height: 330)
    }
}

#Preview {
    ParallaxCarouselView()
}
