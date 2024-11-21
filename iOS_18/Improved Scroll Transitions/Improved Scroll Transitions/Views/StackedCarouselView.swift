//
//  StackedCarouselView.swift
//  Improved Scroll Transitions
//
//  Created by Matteo Buompastore on 21/11/24.
//

import SwiftUI

struct StackedCarouselView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(images) { image in
                        let index = Double(images.firstIndex(where: { $0.id == image.id }) ?? 0)
                        GeometryReader { geo in
                            let minX = geo.frame(in: .scrollView(axis: .horizontal)).minX
                            Image(image.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 220, height: size.height)
                                .clipShape(.rect(cornerRadius: 25))
                                .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                    content
                                        .blur(radius: phase == .identity ? 0 : 2, opaque: false)
                                        .scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
                                        .offset(y: phase == .identity ? 0 : -10)
                                        .rotationEffect(.degrees(phase == .identity ? 0 : phase.value * 5), anchor: .bottom)
                                        .offset(x: minX < 0 ? minX / 2 : -minX)
                                }
                        } //: GEOMETRY
                        .frame(width: 220)
                        .zIndex(-index)
                    } //: Loop
                } //: Lazy HSTACK
                .scrollTargetLayout()
            } //: V-SCROLL
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.horizontal, (size.width - 220) / 2)
        } //: Geometry
        .frame(height: 330)
    }
}

#Preview {
    StackedCarouselView()
}
