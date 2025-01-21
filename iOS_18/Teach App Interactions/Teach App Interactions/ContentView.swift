//
//  ContentView.swift
//  Teach App Interactions
//
//  Created by Matteo Buompastore on 21/01/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var effect: Effect = .pinch
    @State private var showView: Bool = true
    
    var body: some View {
        VStack {
            ZStack {
                if showView {
                    Interactions(effect: effect) { size, showsTouch, animate in
                        /// Inner View Contents
                        switch effect {
                        case .tap:
                            LongPressView(animates: animate, scale: 0.95)
                        case .longPress:
                            LongPressView(animates: animate)
                        case .verticalSwipe:
                            VerticalSwipeView(size, animates: animate)
                        case .horizontalSwipe:
                            HorizontalSwipeView(size, animates: animate)
                        case .pinch:
                            LongPressView(animates: animate, scale: 1.3)
                        }
                    } //: Interactions
                }
            } //: ZSTACK
            .frame(width: 100, height: 200)
            
            Button("Tap") {
                showView = false
                effect = .tap
                Task {
                    showView = true
                }
            }
            .padding(.top)
            
        } //: VSTACK
        .padding()
    }
    
    
    @ViewBuilder
    private func HorizontalSwipeView(_ size: CGSize, animates: Bool) -> some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.fill)
                .frame(width: 80, height: 150)
                .frame(width: size.width, height: size.height)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.fill)
                .frame(width: 80, height: 150)
                .frame(width: size.width, height: size.height)
        } //: VSTACK
        .offset(x: animates ? -(size.width + 10) : 0)
    }
    
    @ViewBuilder
    private func VerticalSwipeView(_ size: CGSize, animates: Bool) -> some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.fill)
                .frame(width: 80, height: 150)
                .frame(width: size.width, height: size.height)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.fill)
                .frame(width: 80, height: 150)
                .frame(width: size.width, height: size.height)
        } //: VSTACK
        .offset(y: animates ? -(size.height + 10) : 0)
    }
    
    @ViewBuilder
    private func LongPressView(animates: Bool, scale: CGFloat = 0.9) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.fill)
            .frame(width: 80, height: 150)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(animates ? scale : 1)
    }
    
}

struct Interactions<Content: View>: View {
    
    var effect: Effect
    @ViewBuilder var content: (CGSize, Bool, Bool) -> Content
    
    /// UI
    @State private var showsTouch: Bool = false
    @State private var animate: Bool = false
    @State private var isStarted: Bool = false
    
    var body: some View {
        /// Dummy iphone bezel
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color.primary, style: .init(lineWidth: 6, lineCap: .round, lineJoin: .round))
            .frame(width: 100, height: 200)
            .background {
                GeometryReader {
                    let size = $0.size
                    content(size, showsTouch, animate)
                } //: GEOMETRY
                .clipped()
            }
            .overlay(alignment: .top) {
                /// Dynamic Island
                Capsule()
                    .frame(width: 22, height: 7)
                    .offset(y: 7)
            }
            .overlay(alignment: .bottom) {
                /// Home Indicator
                Capsule()
                    .frame(width: 32, height: 2)
                    .offset(y: -7)
            }
            .overlay {
                /// Touch View
                let isSwipe = effect == .verticalSwipe || effect == .horizontalSwipe
                let isPinch = effect == .pinch
                let circleSize: CGFloat = effect == .horizontalSwipe ? 18 : 20
                
                Circle()
                    .fill(.fill)
                    .frame(width: circleSize, height: circleSize)
                    .offset(y: isPinch ?(animate ? -40 : 0) : 0)
                    .overlay {
                        if isPinch {
                            Circle()
                                .fill(.fill)
                                .frame(width: circleSize, height: circleSize)
                                .offset(y: animate ? 40 : 0)
                        }
                    }
                    .opacity(showsTouch ? 1 : 0)
                    .blur(radius: showsTouch ? 0 : 5)
                    .offset(
                        x: effect == .horizontalSwipe ? (animate ? -25 : 25) : 0,
                        y: effect == .verticalSwipe ? (animate ? -50 : 50) : 0
                    )
                    .scaleEffect(isSwipe ? 1 : isPinch ? 0.8 : (animate ? 0.8 : 1.1))
            }
            .onAppear {
                /// Avoid calling multiple times
                guard !isStarted else { return }
                isStarted = true
                /// Looping Animation Effect
                Task {
                    await animationEffect()
                }
            }
            .onDisappear {
                isStarted = false
            }
    }
    
    
    private func animationEffect() async {
        /// To avoid recursion calling this infinite times
        guard isStarted else { return }
        
        let isSwipe = effect == .horizontalSwipe || effect == .verticalSwipe
        let isPinch = effect == .pinch
        withAnimation(.easeInOut(duration: 0.5)) {
            showsTouch = true
        }
        
        try? await Task.sleep(for: .seconds(0.5))
        /// Remove delay for tap
        if effect == .tap {
            withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                animate = true
            }
            try? await Task.sleep(for: .seconds(0.2))
        } else {
            withAnimation(.snappy(duration: 1, extraBounce: 0)) {
                animate = true
            }
            
            try? await Task.sleep(for: .seconds(effect == .longPress ? 1.3 : 1))
        }
        
        /// Resetting animation
        withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete) {
            /// Modify animation for long press to obtain a release effect
            /// We don't need revers effect for pinch interaction
            if isSwipe || isPinch {
                showsTouch = false
            } else {
                animate = false
            }
        } completion: {
            if isSwipe {
                animate = false
            }
            if isPinch {
                withAnimation(.linear(duration: 0.2)) {
                    animate = false
                }
            }
        }
        
        try? await Task.sleep(for: .seconds(effect == .tap ? 0.3 : isPinch ? 1 : 0.6))
        await animationEffect()
    }
    
}

#Preview {
    ContentView()
}

enum Effect {
    case tap
    case longPress
    case verticalSwipe
    case horizontalSwipe
    case pinch
}
