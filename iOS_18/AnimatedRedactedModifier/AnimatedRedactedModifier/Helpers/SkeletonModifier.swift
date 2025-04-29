//
//  SkeletonModifier.swift
//  AnimatedRedactedModifier
//
//  Created by Matteo Buompastore on 29/04/25.
//

import SwiftUI

extension View {
    func skeleton(isRedacted: Bool) -> some View {
        self
            .modifier(SkeletonModifier(isRedacted: isRedacted))
    }
}

struct SkeletonModifier: ViewModifier {
    
    // MARK: Properties
    var isRedacted: Bool
    @State private var isAnimating: Bool = false
    @Environment(\.colorScheme) private var scheme
    
    func body(content: Content) -> some View {
        content
            .redacted(reason: isRedacted ? .placeholder : [])
            /// Skeleton Effect
            .overlay {
                if isRedacted {
                    GeometryReader {
                        let size = $0.size
                        let skeletonWidth = size.width / 2
                        
                        /// Limiting blur radius to 30
                        let blurRadius = max(skeletonWidth / 2, 30)
                        let blurDiamter = blurRadius * 2
                        
                        let minX = -(skeletonWidth + blurDiamter)
                        let maxX = size.width + skeletonWidth + blurDiamter
                        
                        Rectangle()
                            .fill(scheme == .dark ? .white : .black)
                            .frame(width: skeletonWidth, height: size.height * 2)
                            .frame(height: size.height)
                            .blur(radius: blurRadius)
                            .rotationEffect(.degrees(rotation))
                        /// Moving from left to right indefinitely
                            .offset(x: isAnimating ? maxX : minX)
                        
                    } //: GEOMETRY
                    .mask {
                        content
                            .redacted(reason: .placeholder)
                    }
                    .blendMode(.softLight)
                    .task {
                        guard !isAnimating else { return }
                        withAnimation(animation) {
                            isAnimating = true
                        }
                    }
                    .onDisappear {
                        isAnimating = false
                    }
                    .transaction {
                        /// To avoid stopping the looping skeleton animation when
                        /// applying animations outside this View
                        if $0.animation != animation {
                            $0.animation = .none
                        }
                    }
                }
            }
    }
    
    
    // MARK: Computed Properties
    var rotation: Double {
        return 5
    }
    
    var animation: Animation {
        .easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    }
    
}

#Preview {
    ContentView()
}
