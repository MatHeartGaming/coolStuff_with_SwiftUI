//
//  View+Extensions.swift
//  ScrollableTabView
//
//  Created by Matteo Buompastore on 22/12/23.
//

import SwiftUI


struct OffsetKey: PreferenceKey {
    
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}


extension View {
    
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
    
    /// Tab bar masking
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(.gray)
            
            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capusleWidth = size.width / CGFloat(Tab.allCases.count)
                        
                        Capsule()
                            .frame(width: capusleWidth)
                            .offset(x: tabProgress * (size.width - capusleWidth))
                    }
                }
        }
    }
    
}


#Preview(body: {
    ContentView()
})
