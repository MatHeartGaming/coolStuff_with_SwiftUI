//
//  RectKey.swift
//  TelegramDarkModeAnimation
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

struct RectKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
    
}
