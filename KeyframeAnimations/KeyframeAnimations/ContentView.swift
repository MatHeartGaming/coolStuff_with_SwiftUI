//
//  ContentView.swift
//  KeyframeAnimations
//
//  Created by Matteo Buompastore on 11/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var startKeyframeAnimaton = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(.xcodeLogo)
                .resizable()
                .frame(width: 200, height: 200)
                .keyframeAnimator(initialValue: Keyframe(), trigger: startKeyframeAnimaton) { view, frame in
                    view
                        .scaleEffect(frame.scale)
                        .rotationEffect(frame.rotation, anchor: .bottom)
                        .offset(y: frame.offsetY)
                        /// Reflection
                        .background {
                            view
                            /// Little Blur
                                .blur(radius: 3)
                                .rotation3DEffect(
                                    .degrees(180),
                                    axis: (x: 1.0, y: 0.0, z: 0.0))
                                .mask(
                                    LinearGradient(colors: [
                                        .white.opacity(frame.reflectionOpacity),
                                        .white.opacity(frame.reflectionOpacity - 0.3),
                                        .white.opacity(frame.reflectionOpacity - 0.45),
                                        .clear
                                    ], startPoint: .top, endPoint: .bottom)
                                )
                                .offset(y: 195)
                        }
                    /// Mask
                        
                } keyframes: { frame in
                    KeyframeTrack(\.offsetY) {
                        CubicKeyframe(10, duration: 0.15)
                        SpringKeyframe(-100, duration: 0.3, spring: .bouncy)
                        CubicKeyframe(-100, duration: 0.45)
                        SpringKeyframe(0, duration: 0.3, spring: .bouncy)
                    }
                    
                    KeyframeTrack(\.scale) {
                        CubicKeyframe(0.9, duration: 0.15)
                        CubicKeyframe(1.2, duration: 0.3)
                        CubicKeyframe(1.2, duration: 0.3)
                        CubicKeyframe(1, duration: 0.3)
                    }
                    
                    KeyframeTrack(\.rotation) {
                        CubicKeyframe(.zero, duration: 0.15)
                        CubicKeyframe(.zero, duration: 0.3)
                        CubicKeyframe(.init(degrees: -20), duration: 0.1)
                        CubicKeyframe(.init(degrees: 20), duration: 0.1)
                        CubicKeyframe(.init(degrees: -20), duration: 0.1)
                        CubicKeyframe(.init(degrees: 0), duration: 0.15)
                    }
                    
                    KeyframeTrack(\.reflectionOpacity) {
                        CubicKeyframe(0.5, duration: 0.15)
                        CubicKeyframe(0.3, duration: 0.75)
                        CubicKeyframe(0.5, duration: 0.3)
                    }
                    
                } //: KEYFRAME ANIMATION IMAGE

            
            Spacer()
            
            Button("Keyframe Animation") {
                startKeyframeAnimaton.toggle()
            }
            .fontWeight(.bold)
            
        } //: VSTACK
        .padding()
    }
}

struct Keyframe {
    var scale: CGFloat = 1
    var offsetY: CGFloat = 0
    var rotation: Angle = .zero
    var reflectionOpacity: CGFloat = 0.5
}

#Preview {
    ContentView()
}
