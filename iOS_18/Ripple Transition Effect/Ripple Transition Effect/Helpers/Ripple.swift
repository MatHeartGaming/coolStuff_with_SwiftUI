//
//  Ripple.swift
//  Ripple Transition Effect
//
//  Created by Matteo Buompastore on 24/02/25.
//

import SwiftUI

extension AnyTransition {
    
    static func ripple(location: CGPoint) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(active: Ripple(location: location, isIdentity: false), identity: Ripple(location: location, isIdentity: true)),
            removal: .modifier(active: IdentityDelayTransition(opacity: 0.99), identity: IdentityDelayTransition(opacity: 1)))
    }
    
    static func reverseRipple(location: CGPoint) -> AnyTransition {
        .modifier(active: Ripple(location: location, isIdentity: false), identity: Ripple(location: location, isIdentity: true))
    }
    
}

fileprivate struct IdentityDelayTransition: ViewModifier {
    
    var opacity: CGFloat
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
    }
}

fileprivate struct Ripple: ViewModifier {
    
    var location: CGPoint
    var isIdentity: Bool
    
    func body(content: Content) -> some View {
        content
            .mask(alignment: .topLeading) {
                MaskShape()
                    .ignoresSafeArea()
            }
    }
    
    private func MaskShape() -> some View {
        GeometryReader {
            let size = $0.size
            let progress: CGFloat = isIdentity ? 1 : 0
            let circleSize: CGFloat = 50
            let circleRadius: CGFloat = circleSize / 2
            
            let fillCircleScale: CGFloat = max(size.width / circleRadius, size.height / circleRadius) + 4
            
            let defaulScale: CGFloat = isIdentity ? 1 : 0
            
            ZStack(alignment: .center) {
                
                Circle()
                    .frame(width: circleSize, height: circleSize)
                
                Circle()
                    .frame(width: circleSize + 10, height: circleSize + 10)
                    .blur(radius: 3)
                
                Circle()
                    .frame(width: circleSize + 20, height: circleSize + 20)
                    .blur(radius: 7)
                
                Circle()
                    .opacity(0.5)
                    .frame(width: circleSize + 30, height: circleSize + 30)
                    .blur(radius: 7)
                
            } //: ZSTACK
            .frame(width: circleSize, height: circleSize)
            .compositingGroup()
            .scaleEffect(defaulScale + (fillCircleScale * progress), anchor: .center)
            .offset(x: location.x - circleRadius, y: location.y - circleRadius)
        } //: GEOMETRY
    }
    
}

#Preview {
    ContentView()
}
