//
//  CoverFlowView.swift
//  CoverFlow With Reflections
//
//  Created by Matteo Buompastore on 15/01/24.
//

import SwiftUI

struct CoverFlowView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    
    //MARK: - PROPERTIES
    
    /// Customization
    var itemWidth: CGFloat
    var enableReflections = false
    var spacing: CGFloat = .zero
    var rotation: CGFloat = .zero
    
    var items: Item
    var content: (Item.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: itemWidth)
                            .reflection(enableReflections)
                            .visualEffect { content, geometryProxy in
                                content
                                    .rotation3DEffect(.degrees(rotation(geometryProxy)),
                                                      axis: (x: 0, y: 1, z: 0),
                                                      anchor: .center)
                            }
                            .padding(.trailing, item.id == items.last?.id ? 0 : spacing)
                    } //: LOOP ITEMS
                } //: LAZY HSTACK
                .padding(.horizontal, (size.width - itemWidth) / 2)
                .scrollTargetLayout()
            } //: SCROLL
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
            
        } //: GEOMETRY
        
    }
    
    
    //MARK: - Functions
    func rotation(_ proxy: GeometryProxy) -> Double {
        let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
        /// Converting into progress
        let progress = midX / scrollViewWidth
        /// Capping progress 0-1
        let cappedProgress = max(min(progress, 1), 0)
        
        /// Limit rotation between 0-90°
        let cappedRotation = max(min(rotation, 90), 0)
        
        let degree = cappedProgress * (cappedRotation * 2)
        
        return cappedRotation - degree
    }
    
}

struct CoverFlowItem: Identifiable {
    
    let id = UUID()
    var color: Color
    
}

/// View Extension for Reflections
fileprivate extension View {
    
    @ViewBuilder
    func reflection(_ added: Bool) -> some View {
        self
            .overlay {
                if added {
                    GeometryReader {
                        let size = $0.size
                        
                        self
                        /// Flipping Upside Down
                            .scaleEffect(y: -1)
                            .mask {
                                Rectangle()
                                    .fill(
                                        .linearGradient(colors: [
                                            .white,
                                            .white.opacity(0.7),
                                            .white.opacity(0.5),
                                            .white.opacity(0.3),
                                            .white.opacity(0.1),
                                            .white.opacity(0),
                                        ] + Array(repeating: Color.clear, count: 5),
                                                        startPoint: .top, endPoint: .bottom))
                            } //: MASK RECT GRADIENT
                        /// Move to bottom
                            .offset(y: size.height + 5)
                            .opacity(0.5)
                    } //: GEOMETRY
                }
            }
    }
    
}

#Preview {
    let items: [CoverFlowItem] = [.red, .blue, .green, .yellow].compactMap { color in
            .init(color: color)
    }
    return CoverFlowView(itemWidth: 250,
                         enableReflections: true,
                         spacing: 10,
                         rotation: 0,
                         items: items) { item in
               RoundedRectangle(cornerRadius: 20)
                   .fill(item.color.gradient)
           }
           .frame(height: 180)
}

#Preview {
    ContentView()
}
