//
//  ViewExtensions.swift
//  ShowcaseView
//
//  Created by Matteo Buompastore on 05/12/23.
//

import SwiftUI

/// Custom showcase View extension
extension View {
    
    @ViewBuilder
    func showCase(order: Int, title: String, cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous, scale: CGFloat = 1) -> some View {
        self
        /// Storinng it in Anchor preference
            .anchorPreference(key: HighlightAnchorKey.self, value: .bounds, transform: { anchor in
                let highlight = Highlight(anchor: anchor, title: title, cornerRadius: cornerRadius,
                                          style: style, scale: scale)
                return [order: highlight]
            })
    }
    
}

/// Custom View Modifier for Inner / Reverse Mask
extension View {
    
    @ViewBuilder
    func reverseMask<Content: View>(alignment: Alignment = .topLeading, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: alignment, content: {
                        content()
                            .blendMode(.destinationOut)
                    })
            }
    }
    
}

/// Anchor key
struct HighlightAnchorKey: PreferenceKey {
    
    static var defaultValue: [Int: Highlight] = [:]
    
    static func reduce(value: inout [Int : Highlight], nextValue: () -> [Int : Highlight]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
    
}
