//
//  ShapeMorphingView.swift
//  GooeyEffect
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct ShapeMorphingView: View {
    
    // MARK: - PROPERTIES
    var systemImage: String
    var fontSize: CGFloat
    var color: Color = .white
    var duration: CGFloat = 0.5
    
    // MARK: - UI
    @State private var newImage: String = ""
    @State private var radius: CGFloat = .zero
    @State private var animatedRadiusValue: CGFloat = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            Canvas { ctx, size in
                ctx.addFilter(.alphaThreshold(min: 0.5, color: color))
                ctx.addFilter(.blur(radius: animatedRadiusValue))
                
                ctx.drawLayer { contextLayer in
                    if let resolvedImageView = ctx.resolveSymbol(id: 0) {
                        contextLayer.draw(resolvedImageView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                    }
                }
                
            } symbols: {
                ImageView(size: size)
                    .tag(0)
            } //: CANVAS
            
        } //: GEOMETRY
        .onAppear {
            print("New Image \(newImage.isEmpty)")
            if newImage.isEmpty {
                newImage = systemImage
            }
        }
        /// Updating image
        .onChange(of: systemImage) { oldValue, newValue in
            newImage = newValue
            withAnimation(.linear(duration: duration).speed(2)) {
                radius = 12
            }
        }
        .animationProgress(endValue: radius) { value in
            animatedRadiusValue = value
            if value >= 6 {
                withAnimation(.linear(duration: duration).speed(2)) {
                    radius = 0
                }
            }
        }
    }
    
    @ViewBuilder
    func ImageView(size: CGSize) -> some View {
        Image(systemName: !newImage.isEmpty ? newImage : systemImage)
            .font(.system(size: fontSize))
            .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.9), value: newImage)
            .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.9), value: fontSize)
        /// Fixing place at one poing
            .frame(width: size.width, height: size.height)
    }
    
}

#Preview {
    ContentView()
}
