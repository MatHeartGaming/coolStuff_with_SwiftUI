//
//  KeyFrameExample.swift
//  AdvancedAnimationsAPIs
//
//  Created by Matteo Buompastore on 29/04/25.
//

import SwiftUI

struct KeyFrameExample: View {
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 45, height: 45)
                
                VStack(alignment: .leading) {
                    
                    MarqueeText(text: "Hello world, this is a Marquee Text using KeyFrames APIs")
                    
                    Text("By MatBuompy")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
            } //: HSTACK
            .padding(15)
            .background(.background, in: .rect(cornerRadius: 12))
        } //: VSTACK
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.15))
    }
}

struct MarqueeText: View {
    
    var text: String
    
    /// UI
    @State private var textSize: CGSize = .zero
    @State private var viewSize: CGSize = .zero
    @State private var isMarqueeEnabled: Bool = false
    
    var body: some View {
        ScrollView(.horizontal) {
            Text(text)
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: { newValue in
                    textSize = newValue
                    isMarqueeEnabled = textSize.width > viewSize.width
                }
                .modifiers { content in
                    if isMarqueeEnabled {
                        content
                            .keyframeAnimator(initialValue: 0.0, repeating: true) { [textSize, gap] content, progress in
                                let offset = textSize.width + gap
                                
                                content
                                    .overlay(alignment: .trailing) {
                                        content
                                            .offset(x: offset)
                                    }
                                    .offset(x: -offset * progress)
                            } keyframes: { _ in
                                LinearKeyframe(0, duration: holdTime)
                                LinearKeyframe(1, duration: speed)
                            }

                    } else {
                        content
                    }
                }

        }
        .scrollDisabled(true)
        .scrollIndicators(.hidden)
        .onGeometryChange(for: CGSize.self) {
            $0.size
        } action: { newValue in
            viewSize = newValue
        }
    }
    
    
    /// Customisation Properties
    /// Hold time for next iteration
    var holdTime: CGFloat {
        return 2
    }
    
    var speed: CGFloat {
        return 6
    }
    
    /// Gap
    var gap: CGFloat {
        return 25
    }
    
}

extension View {
    
    /// Conditional based view Modifiers
    @ViewBuilder
    func modifiers<Content: View>(@ViewBuilder content: @escaping (Self) -> Content ) -> some View {
        content(self)
    }
    
}

#Preview {
    NavigationStack {
        KeyFrameExample()
            .navigationTitle("KeyFrames")
            .navigationBarTitleDisplayMode(.inline)
    }
}
