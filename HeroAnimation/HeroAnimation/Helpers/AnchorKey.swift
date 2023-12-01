//
//  AnchorKey.swift
//  HeroAnimation
//
//  Created by Matteo Buompastore on 01/12/23.
//

import SwiftUI

struct AnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) {
            $1
        }
    }
    
}
