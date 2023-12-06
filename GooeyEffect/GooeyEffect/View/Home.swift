//
//  Home.swift
//  GooeyEffect
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct Home: View {
    
    var size: CGSize
    
    // MARK: - UI
    @State private var isExpanded = false
    @State private var radius: CGFloat = 10
    @State private var animatedRaius: CGFloat = 10
    @State private var scale: CGFloat = 1
    
    /// Offsets
    @State private var baseOffset: [Bool] = Array(repeating: false, count: 5)
    @State private var secondaryOffsets: [Bool] = Array(repeating: false, count: 2)
    @State private var showIcons: [Bool] = Array(repeating: false, count: 2)
    
    
    var body: some View {
        VStack {
            /// Share Button
            ///  Since we'll have 5 buttons...
            let padding: CGFloat = 30
            let circleSize = (size.width - padding) / 5
            ZStack {
                ShapeMorphingView(
                    systemImage: isExpanded ? "xmark.circle.fill" : "square.and.arrow.up.fill",
                    fontSize: isExpanded ? circleSize * 0.9 : 35,
                    color: .white
                )
                .scaleEffect(isExpanded ? 0.6 : 1)
                .background(
                    Rectangle()
                        .fill(.gray.gradient)
                        .mask {
                            Canvas { ctx, size in
                                /// Same technique as shape morph
                                ctx.addFilter(.alphaThreshold(min: 0.5))
                                ctx.addFilter(.blur(radius: animatedRaius))
                                
                                /// Drawing symbols
                                ctx.drawLayer { ctx1 in
                                    /// Since we have 5 symbols with 5 tags
                                    for index in 0..<5 {
                                        if let resolvedShareButton = ctx.resolveSymbol(id: index) {
                                            ctx1.draw(resolvedShareButton, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                        }
                                    }
                                }
                            } symbols: {
                                GroupedShareButtons(size: circleSize, fillColor: true)
                            }
                        }
                )
                GroupedShareButtons(size: circleSize, fillColor: false)
            } //: ZSTACK Buttons
            .frame(height: circleSize)
            
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: isExpanded) { oldValue, newValue in
            if newValue {
                /// First show base offset icons
                withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
                    showIcons[0] = true
                }
                
                /// Next show secondary offset icons
                withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
                    showIcons[1] = true
                }
            } else {
                withAnimation(.easeInOut(duration: 0.15)) {
                    showIcons[0] = false
                    showIcons[1] = false
                }
            }
        }
    }
    
    @ViewBuilder
    func GroupedShareButtons(size: CGFloat, fillColor: Bool = true) -> some View {
        Group {
            ShareButton(
                size: size,
                tag: 0,
                icon: "Steam",
                showIcon: showIcons[1],
                renderingMode: .original) {
                    return (baseOffset[0] ? -size : .zero) + (secondaryOffsets[0] ? -size : 0)
                }
            
            ShareButton(
                size: size,
                tag: 1,
                icon: "Twitter",
                showIcon: showIcons[0],
                renderingMode: .template) {
                    return (baseOffset[1] ? -size : .zero)
                }
            
            ShareButton(
                size: size,
                tag: 2,
                icon: "",
                showIcon: false,
                renderingMode: .template) {
                    return 0
                }
                /// Masking it on top of all Views, for inital tap
                .zIndex(1000)
                .onTapGesture {
                    toggleShareButton()
                }
            
            
            ShareButton(
                size: size,
                tag: 3,
                icon: "Facebook",
                showIcon: showIcons[0],
                renderingMode: .original) {
                    return (baseOffset[3] ? size : .zero)
                }
            
            ShareButton(
                size: size,
                tag: 4,
                icon: "Gmail",
                showIcon: showIcons[1],
                renderingMode: .template) {
                    return (baseOffset[4] ? size : .zero) + (secondaryOffsets[1] ? size : 0)
                }
        }
        .foregroundStyle(fillColor ? .black : .clear)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animationProgress(endValue: radius) { value in
            animatedRaius = value
            
            if value >= 15 {
                withAnimation(.easeInOut(duration: 0.4)) {
                    radius = 10
                }
            }
        }
    }
    
    /// Individual Share Button
    @ViewBuilder
    func ShareButton(size: CGFloat, tag: Int, icon: String, showIcon: Bool, renderingMode: Image.TemplateRenderingMode = .template, offset: @escaping () -> CGFloat) -> some View {
        Circle()
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .overlay {
                if !icon.isEmpty {
                    Image(icon)
                        .resizable()
                        .renderingMode(renderingMode)
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: size * 0.3)
                        /// Showing Icon when showIcon is true
                        .opacity(showIcon ? 1 : 0)
                        .scaleEffect(showIcon ? 1 : 0)
                } //: ICON
            } //: CIRCLE OVERLAY
            .contentShape(Circle())
            .offset(x: offset())
            .tag(tag)
    }
    
    // MARK: - FUNCTIONS
    func toggleShareButton() {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.4)) {
            isExpanded.toggle()
            scale = isExpanded ? 0.75 : 1
        }
        
        /// Updating Radius for more Fluidity
        withAnimation(.easeIn(duration: 0.4)) {
            radius = 20
        }
        
        for index in baseOffset.indices {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.8)) {
                baseOffset[index].toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            for index in secondaryOffsets.indices {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.8)) {
                    secondaryOffsets[index].toggle()
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
