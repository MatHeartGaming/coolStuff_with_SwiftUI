//
//  RectAnchorKey.swift
//  Netflix UI Animations
//
//  Created by Matteo Buompastore on 23/04/24.
//

import SwiftUI

struct RectAnchorKey: PreferenceKey {
    
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
    
}

struct RectKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
