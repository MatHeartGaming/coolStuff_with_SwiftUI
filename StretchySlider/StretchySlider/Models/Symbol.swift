//
//  Symbol.swift
//  StretchySlider
//
//  Created by Matteo Buompastore on 09/02/24.
//

import SwiftUI

/// Slider SFSymbol config and orientation
struct Symbol {
    let icon: String
    var tint: Color
    var font: Font
    var padding: CGFloat
    var display: Bool = true
    var alignment: Alignment = .center
}

enum SliderAxis {
    case vertical
    case horizontal
}
