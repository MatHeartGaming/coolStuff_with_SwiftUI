//
//  ContentView.swift
//  ShineEffectModifier
//
//  Created by Matteo Buompastore on 30/11/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @State private var shinePic = false
    @State private var shineButton = false
    
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack {
                
                Button("Share Post", systemImage: "square.and.arrow.up") {
                    shineButton.toggle()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .shine(shineButton, clipShape: .capsule)
                
                Image("mat")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .shine(shinePic, duration: 1, clipShape: .rect(cornerRadius: 20))
                    .onTapGesture {
                        shinePic.toggle()
                    }
            } //: VSTACK
            
        } //: NAVIGATION
    }
}

extension View {
    
    @ViewBuilder
    func shine(_ toggle: Bool, duration: CGFloat = 0.5, clipShape: some Shape = .rect, rightToLeft: Bool = false) -> some View {
        self
            .overlay(
                GeometryReader{
                    let size = $0.size
                    
                    /// Eliminating negative duration
                    let moddedDuration = max(0.3, duration)
                    
                    Rectangle()
                        .fill(.linearGradient(
                            colors: [
                                .clear,
                                .clear,
                                .white.opacity(0.1),
                                .white.opacity(0.5),
                                .white.opacity(1),
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .clear,
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )) //: RECTANGLE
                        .scaleEffect(y: 8)
                        .keyframeAnimator(initialValue: 0, trigger: toggle, content: { content, progress in
                            content
                                .offset(x: -size.width + (progress * (size.width * 2)))
                        }, keyframes: { frames in
                            CubicKeyframe(.zero, duration: 0.1)
                            CubicKeyframe(1, duration: moddedDuration)
                        })
                        .rotationEffect(.degrees(45))
                        .scaleEffect(x: rightToLeft ? -1 : 1)
                }
            ) //: OVERLAY
            .clipShape(clipShape)
    }
    
}

#Preview {
    ContentView()
}
