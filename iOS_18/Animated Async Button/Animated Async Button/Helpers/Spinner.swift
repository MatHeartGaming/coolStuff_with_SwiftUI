//
//  Spinner.swift
//  Animated Async Button
//
//  Created by Matteo Buompastore on 28/04/25.
//

import SwiftUI

struct Spinner: View {
    
    // MARK: Properties
    var tint: Color
    var lineWidth: CGFloat = 4
    
    /// UI
    @State private var rotation: Double = 0
    @State private var extraRotation: Double = 0
    @State private var isAnimatedTriggered: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(tint.opacity(0.3), style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            
            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(tint, style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(rotation))
                .rotationEffect(.degrees(extraRotation))
            
        } //: ZSTACK
        .compositingGroup()
        .onAppear(perform: animate)
    }
    
    
    // MARK: Functions
    private func animate() {
        guard !isAnimatedTriggered else { return }
        isAnimatedTriggered = true
        
        withAnimation(.linear(duration: 0.7).speed(1.2).repeatForever(autoreverses: false)) {
            self.rotation += 360
        }
        
        withAnimation(.linear(duration: 1).speed(1.2).delay(1).repeatForever(autoreverses: false)) {
            extraRotation += 360
        }
    }
    
}

#Preview {
    Spinner(tint: .green, lineWidth: 4)
        .frame(width: 30, height: 30)
}
