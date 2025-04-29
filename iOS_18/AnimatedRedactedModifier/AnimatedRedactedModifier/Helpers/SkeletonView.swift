//
//  SkeletonView.swift
//  SkeletonLoadingView
//
//  Created by Matteo Buompastore on 29/04/25.
//

import SwiftUI

struct SkeletonView<S: Shape>: View {
    
    // MARK: Properties
    var shape: S
    var color: Color
    
    init(_ shape: S, _ color: Color = .gray.opacity(0.3)) {
        self.shape = shape
        self.color = color
    }
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        shape
            .fill(color)
        /// Skeleton Effect
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let skeletonWidth = size.width / 2
                    
                    /// Limiting blur radius to 30
                    let blurRadius = max(skeletonWidth / 2, 30)
                    let blurDiamter = blurRadius * 2
                    
                    let minX = -(skeletonWidth + blurDiamter)
                    let maxX = size.width + skeletonWidth + blurDiamter
                    
                    Rectangle()
                        .fill(.gray)
                        .frame(width: skeletonWidth, height: size.height * 2)
                        .frame(height: size.height)
                        .blur(radius: blurRadius)
                        .rotationEffect(.degrees(rotation))
                        .blendMode(.softLight)
                        /// Moving from left to right indefinitely
                        .offset(x: isAnimating ? maxX : minX)
                        
                } //: GEOMETRY
            }
            .clipShape(shape)
            .compositingGroup()
            .onAppear {
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
    
    
    // MARK: Computed Properties
    var rotation: Double {
        return 5
    }
    
    var animation: Animation {
        .easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    }
}

#Preview {
    @Previewable
    @State var isTapped: Bool = false
    
    SkeletonView(.circle)
        .frame(width: 100, height: 100)
        .onTapGesture {
            withAnimation(.smooth) {
                isTapped.toggle()
            }
        }
        .padding(.bottom, isTapped ? 15 : 0)
}
