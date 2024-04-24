//
//  Interpolation.swift
//  Scrollable Tab Bar
//
//  Created by Matteo Buompastore on 24/04/24.
//

import SwiftUI

extension CGFloat {
    
    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
        /// If Value less than it's Initial Input Range
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] { return outputRange[0] }
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]
            /// Linear Interpolation Formula: y1 + ((y2-y1) / (x2-x1)) * (x-x1)
            if x <= inputRange[index] {
                let y = y1 + ( (y2-y1) / (x2-x1)) * (x-x1)
                return y
            }
        }
        /// If Value Exceeds it's Maximum Input Range return outputRange[length]
        return outputRange[length]
    }
}
