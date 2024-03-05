//
//  ContentView.swift
//  VisualEffectAPI StackedCards
//
//  Created by Matteo Buompastore on 05/03/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State private var isRotationEnabled: Bool = false
    @State private var showIndicator: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(items) { item in
                                CardView(item)
                                    .padding(.horizontal, 65)
                                    .frame(width: size.width)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .scaleEffect(scale(geometryProxy, scale: 0.1), anchor: .trailing)
                                            .rotationEffect(rotation(geometryProxy, rotation: isRotationEnabled ? 5 : 0))
                                            .offset(x: minX(geometryProxy))
                                            .offset(x: excessMinX(geometryProxy, offset: isRotationEnabled ? 8 : 10))
                                    }
                                    .zIndex(items.zIndex(item))
                            } //: Loop Items
                        } //: HSTACK
                        .padding(.vertical, 15)
                    } //: SCROLL
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(showIndicator ? .visible : .hidden)
                    .scrollIndicatorsFlash(trigger: showIndicator)
                    
                } //: GEOMETRY
                .frame(height: 410)
                .animation(.snappy, value: isRotationEnabled)
                
                VStack(spacing: 10) {
                    Toggle("Rotation Enabled", isOn: $isRotationEnabled)
                    Toggle("Show Scroll Indicator", isOn: $showIndicator)
                } //: VSTACK
                .padding(15)
                .background(.bar, in: .rect(cornerRadius: 10, style: .continuous))
                .padding(15)
                
            } //: VSTACK
            .navigationTitle("Stacked Cards")
        } //: NAVIGATION
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func CardView(_ item: Item) -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(item.color.gradient)
    }
    
    
    //MARK: - Functions
    
    /// Stacked Card Animation
    private func minX(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX < 0 ? 0 : -minX
    }
    
    /// Limit is the number of cards visible on the trailing side
    private func progress(_ proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        
        /// Converting into progress
        let progress = (maxX / width) - 1.0
        let cappedProgress = min(progress, limit)
        return cappedProgress
    }
    
    private func scale(_ proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
        let progress = progress(proxy)
        
        return 1 - (progress * scale)
    }
    
    private func excessMinX(_ proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
        let progress = progress(proxy)
        return progress * offset
    }
    
    private func rotation(_ proxy: GeometryProxy, rotation: CGFloat = 10) -> Angle {
        let progress = progress(proxy)
        return .degrees(progress * rotation)
    }
    
}

#Preview {
    ContentView()
}
