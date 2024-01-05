//
//  OffsetKey.swift
//  MaterialCarouselSlider
//
//  Created by Matteo Buompastore on 05/01/24.
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
    func offsetX(compeltion: @escaping (CGFloat) -> Void) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView).minX
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: { value in
                            compeltion(value)
                        })
                }
            }
    }
    
}

/// Card Array Extension
extension [Card] {
    
    func indexOf(_ card: Card) -> Int {
        return self.firstIndex(of: card) ?? 0
    }
    
}
