//
//  StackedCards.swift
//  Stacked Scroll View
//
//  Created by Matteo Buompastore on 20/05/24.
//

import SwiftUI

struct StackedCards<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    
    var items: Data
    var stackedDisplayCount: Int = 2
    var opacityDisplayCount: Int = 2
    var spacing: CGFloat = 5
    var itemHeight: CGFloat
    @ViewBuilder var content: (Data.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let topPadding: CGFloat = size.height - itemHeight
            
            ScrollView(.vertical) {
                VStack(spacing: spacing) {
                    ForEach(items) { item in
                        content(item)
                            .frame(height: itemHeight)
                            .visualEffect { content, geometryProxy in
                                content
                                    .opacity(opacity(geometryProxy))
                                    .scaleEffect(scale(geometryProxy), anchor: .bottom)
                                    .offset(y: offset(geometryProxy))
                            }
                            .zIndex(zIndex(item))
                    } //: Loop items
                } //: VSTACK
                .overlay(alignment: .top) {
                    HeaderView(topPadding)
                }
                .scrollTargetLayout()
            } //: V-SCROLL
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.top, topPadding)
        } //: GEOMETRY
    }
    
    
    //MARK: - Functions
    
    /// Header View
    @ViewBuilder
    private func HeaderView(_ topPadding: CGFloat) -> some View {
        VStack(spacing: 0) {
            Text(Date.now.formatted(date: .complete, time: .omitted))
                .font(.title3.bold())
            
            Text("10.13")
                .font(.system(size: 100, weight: .bold, design: .rounded))
                .padding(.top, -15)
        } //: VSTACK
        .foregroundStyle(.white)
        .visualEffect { content, geometryProxy in
            content
                .offset(y: headerOffsert(geometryProxy, topPadding))
        }
    }
    
    /// Header Offset
    private func headerOffsert(_ proxy: GeometryProxy, _ topPadding: CGFloat) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let viewSize = proxy.size.height - itemHeight
        return -minY > (topPadding - viewSize) ? -viewSize : -minY - topPadding
    }
    
    /// Zindex to reverse the Stack
    func zIndex(_ item: Data.Element) -> Double {
        if let index = items.firstIndex(where: { $0.id == item.id }) as? Int {
            return Double(items.count - index)
        }
        return 0
    }
    
    /// Offset & Scaling values For Each Item to make it look like a Stack
    private func offset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let maxOffset = CGFloat(stackedDisplayCount) * offsetForEachItem
        let offset = max(min(progress * offsetForEachItem, maxOffset), 0)
        return minY < 0 ? 0 : -minY + offset
    }
    
    private func scale(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let maxScale = CGFloat(stackedDisplayCount) * scaleForEachItem
        let scale = max(min(progress * scaleForEachItem, maxScale), 0)
        return 1 - scale
    }
    
    private func opacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let opacityForitem = 1 / CGFloat(opacityDisplayCount + 1)
        let maxOpacity = CGFloat(opacityForitem) * CGFloat(opacityDisplayCount + 1)
        let opacity = max(min(progress * opacityForitem, maxOpacity), 0)
        return progress < CGFloat(opacityDisplayCount + 1) ? 1 - opacity : 0
    }
    
    
    /// Used to move and scale extra items on the Stack
    private var offsetForEachItem: CGFloat {
        return 8
    }
    
    private var scaleForEachItem: CGFloat {
        return 0.08
    }
    
}

#Preview {
    ContentView()
}
