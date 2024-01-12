//
//  OffsetKey.swift
//  Complex Hero Animation with Synch ScrollViews
//
//  Created by Matteo Buompastore on 12/01/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
        
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) {
            $1
        }
    }
    
}
