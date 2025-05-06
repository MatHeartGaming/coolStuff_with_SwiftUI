//
//  SlideToConfirm.swift
//  Slide To Confirm
//
//  Created by Matteo Buompastore on 06/05/25.
//

import SwiftUI

struct SlideToConfirm: View {
    
    // MARK: Properties
    var config: Config
    var onSwiped: () -> Void
    
    /// UI
    @State private var animateText: Bool = false
    @State private var offsetX: CGFloat = 0
    @State private var isCompleted: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let knobSize = size.height
            let maxLimit = size.width - knobSize
            let progress: CGFloat = isCompleted ? 1 : (offsetX / maxLimit)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(
                        .gray.opacity(0.25)
                        .shadow(.inner(color: .black.opacity(0.2), radius: 10)))
                
                let extraCapsuleWidth = (size.width - knobSize) * progress
                Capsule()
                    .fill(config.tint.gradient)
                    .frame(width: knobSize + extraCapsuleWidth, height: knobSize)
                
                LeadingTextView(size, progress: progress)
                
                HStack(spacing: 0) {
                    
                    KnobView(size, progress: progress, maxLimit: maxLimit)
                        .zIndex(1)
                    
                    /// Shimmer Text
                    ShimmerTextView(size, progress: progress)
                    
                } //: HSTACK
            } //: ZSTACK
        } //: GEOMETRY
        .frame(height: isCompleted ? 50 : config.height)
        .containerRelativeFrame(.horizontal) { value, _ in
            let ratio: CGFloat = isCompleted ? 0.5 : 0.8
            return value * ratio
        }
        .frame(maxWidth: 300)
        /// Disabling User interactions when swipe is done
        .allowsHitTesting(!isCompleted)
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func KnobView(_ size: CGSize, progress: CGFloat, maxLimit: CGFloat) -> some View {
        Circle()
            .fill(.background)
            .padding(6)
            .frame(width: size.height, height: size.height)
            .overlay {
                ZStack {
                    Image(systemName: "chevron.right")
                        .opacity(1 - progress)
                        .blur(radius: progress * 10)
                    
                    Image(systemName: "checkmark")
                        .opacity(progress)
                        .blur(radius: (1 - progress) * 10)
                }
                .font(.title3.bold())
            }
            .contentShape(.circle)
            .scaleEffect(isCompleted ? 0.6 : 1, anchor: .center)
            .offset(x: isCompleted ? maxLimit : offsetX)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let knobSize = size.height
                        let maxLimit = size.width - knobSize
                        offsetX = min(max(value.translation.width, 0), maxLimit)
                    }.onEnded { value in
                        if offsetX == maxLimit {
                            onSwiped()
                            animateText = false
                            
                            withAnimation(.smooth) {
                                isCompleted = true
                            }
                        } else {
                            withAnimation(.smooth) {
                                offsetX = 0
                            }
                        }
                    }
            )
    }
    
    @ViewBuilder
    private func ShimmerTextView(_ size: CGSize, progress: CGFloat) -> some View {
        Text(isCompleted ? config.confirmationText : config.idleText)
            .foregroundStyle(.gray.opacity(0.6))
            .overlay {
                Rectangle()
                    .frame(height: 15)
                    .rotationEffect(.degrees(90))
                    .visualEffect { [animateText] content, proxy in
                        content
                            .offset(x: -proxy.size.width / 1.8)
                            .offset(x: animateText ? proxy.size.width * 1.2 : 0)
                    }
                    .mask(alignment: .leading) {
                        Text(config.idleText)
                    }
                    .blendMode(.softLight)
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.trailing, size.height / 2)
            .mask {
                Rectangle()
                    .scale(x: 1 - progress, anchor: .trailing)
            }
            .frame(height: size.height)
            .task {
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                    animateText = true
                }
            }
    }
    
    @ViewBuilder
    func LeadingTextView(_ size: CGSize, progress: CGFloat) -> some View {
        ZStack {
            Text(config.onSwipeText)
                .opacity(isCompleted ? 0 : 1)
                .blur(radius: isCompleted ? 10 : 0)
            
            Text(config.confirmationText)
                .opacity(!isCompleted ? 0 : 1)
                .blur(radius: !isCompleted ? 10 : 0)
        }
        
        .fontWeight(.semibold)
        .foregroundStyle(config.foregroundColor)
        .frame(maxWidth: .infinity)
        /// Center it
        .padding(.trailing, (size.height * (isCompleted ? 0.6 : 1)) / 2)
        .mask {
            Rectangle()
                .scale(x: progress, anchor: .leading)
        }
        
    }
    
    
    struct Config {
        var idleText: String
        var onSwipeText: String
        var confirmationText: String
        var tint: Color
        var foregroundColor: Color
        var height: CGFloat = 70
    }
}

#Preview {
    let config = SlideToConfirm.Config(
        idleText: "Slide to Pay",
        onSwipeText: "Confirm Payment",
        confirmationText: "Success!",
        tint: .green,
        foregroundColor: .white
    )
    SlideToConfirm(config: config, onSwiped: {
        print("Swiped")
    })
}

#Preview("Content View") {
    ContentView()
}
