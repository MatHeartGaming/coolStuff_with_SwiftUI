//
//  IsometricView.swift
//  Isometric Transform
//
//  Created by Matteo Buompastore on 10/01/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - UI
    @State private var animate = false
    
    /// Animation
    @State private var b: CGFloat = 0
    @State private var c: CGFloat = 0
    
    var body: some View {
        VStack {
            IsometricView(depth: animate ? 15 : 0) {
                ImageView()
            } bottom: {
                ImageView()
            } side: {
                ImageView()
            }
            .frame(width: 180, height: 330)
            /// Animating it
            .modifier(CustomProjection(b: b, c: c))
            .rotation3DEffect(.degrees(animate ? 45 : 0),
                              axis: (x: 0.0, y: 0, z: 1.0))
            .scaleEffect(0.75)
            .offset(x: animate ? 12 : 0)
            
            VStack(alignment: .leading, spacing: 25) {
                Text("Isometric Transform")
                    .font(.title.bold())
                    
                HStack {
                    Button("Animate") {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                            animate = true
                            b = -0.2
                            c = -0.3
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    
                    Button("Slow Animation") {
                        withAnimation(.easeInOut(duration: 2.5)) {
                            animate = true
                            b = -0.2
                            c = -0.3
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    
                    Button("Reset") {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                            animate = false
                            b = 0
                            c = 0
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                } //: HSTACK
                .padding(.horizontal, 15)
                .padding(.top, 20)
            } //: VSTACK
            .frame(maxWidth: .infinity, alignment: .leading)
            
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    }
    
    // MARK: - Views
    
    @ViewBuilder
    func ImageView() -> some View {
        Image(.BG)
            .resizable()
            .scaledToFill()
            .frame(width: 180, height: 330)
            .clipped()
    }
    
}

struct CustomProjection: GeometryEffect {
    
    var b: CGFloat
    var c: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            return AnimatablePair(b, c)
        }
        set {
            b = newValue.first
            c = newValue.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return .init(.init(a: 1, b: b, c: c, d: 1, tx: 0, ty: 0))
    }
    
}

struct IsometricView<Content: View, Bottom: View, Side: View>: View {
    
    @ViewBuilder var content: Content
    @ViewBuilder var bottom: Bottom
    @ViewBuilder var side: Side
    
    /// Isometric depth
    var depth: CGFloat
    
    init(depth: CGFloat = 10, @ViewBuilder content: @escaping () -> Content, @ViewBuilder bottom: @escaping () -> Bottom, side: @escaping () -> Side) {
        self.content = content()
        self.bottom = bottom()
        self.side = side()
        self.depth = depth
    }
    
    
    var body: some View {
        /// For Geometry to take the specified space
        Color.clear
            .overlay {
                GeometryReader {
                    let size = $0.size
                    
                    ZStack {
                        content
                        
                        DepthView(isBottom: true, size: size)
                        
                        DepthView(isBottom: false, size: size)
                        
                    } //: ZSTACK
                    .frame(width: size.width, height: size.height)
                } //: GEOMETRY
            } //: OVERLAY
    }
    
    
    //MARK: - Views
    
    func DepthView(isBottom: Bool = false, size: CGSize) -> some View {
        ZStack {
            /// If you don't want the original image but need a strecth at sides and bottom use this method
            if isBottom {
                bottom
                    .scaleEffect(y: depth, anchor: .bottom)
                    .frame(height: depth, alignment: .bottom)
                    /// Dimming content with blur
                    .overlay {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    }
                    .clipped()
                    /// Applying transorms
                    .projectionEffect(ProjectionTransform(.init(a: 1, b: 0, c: 1, d: 1, tx: 0, ty: 0)))
                    .offset(y: depth)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                side
                    .scaleEffect(x: depth, anchor: .trailing)
                    .frame(width: depth, alignment: .trailing)
                    .overlay {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    }
                    .clipped()
                    /// Applying transorms
                    .projectionEffect(ProjectionTransform(.init(a: 1, b: 1, c: 0, d: 1, tx: 0, ty: 0)))
                    /// Change these according to your needs
                    //.offset(x: -depth, y: depth)
                    .offset(x: depth)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
}


#Preview {
    Home()
}
