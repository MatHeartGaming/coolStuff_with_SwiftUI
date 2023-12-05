//
//  ShimmerEffect.swift
//  ShimmerEffect
//
//  Created by Matteo Buompastore on 05/12/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config))
    }
}

// Shimmer effect helper
fileprivate struct ShimmerEffectHelper: ViewModifier {
    
    var config: ShimmerConfig
    
    //MARK: - Animation Properties
    @State private var moveTo: CGFloat = -0.5
    
    func body(content: Content) -> some View {
        content
        /// Adding shimmer effect using the mask modifier
        /// Hiding the normal one and adding the shimmer one instead
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        /// Shimmer
                        GeometryReader{ geometry in
                            let size = geometry.size
                            let extraOffset = size.height / 2.5
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    /// Gradient for glowing at the center
                                    Rectangle()
                                        .fill(.linearGradient(colors: [.white.opacity(0),
                                                                       config.highlight.opacity(config.highlightOpactity)
                                                                      ],
                                                              startPoint: .top,
                                                              endPoint: .bottom)
                                        )
                                    /// Blur
                                        .blur(radius: config.blur)
                                        .rotationEffect(.degrees(-70))
                                    /// Move to start
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                        
                                } //: MASK RECTANGLE
                        } //: GEOMETRY
                        .mask {
                            content
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            } //: OVERLAY
    }
    
}

struct ShimmerConfig {
    
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var highlightOpactity: CGFloat = 1
    var speed: CGFloat = 2
    
}

#Preview {
    ContentView()
}
