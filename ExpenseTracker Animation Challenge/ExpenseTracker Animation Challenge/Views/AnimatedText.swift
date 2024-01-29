//
//  AnimatedText.swift
//  ExpenseTracker Animation Challenge
//
//  Created by Matteo Buompastore on 29/01/24.
//

import SwiftUI

struct AnimatedText: Animatable, View {
    
    //MARK: - Properties
    var value: CGFloat
    
    /// Optional properties
    var font: Font?
    var floatingPoint: Int = 2
    var isCurrency: Bool = false
    var additionalString: String = ""
    
    var animatableData: CGFloat {
        get { value }
        set { value = newValue }
    }
    
    var body: some View {
        Text("\(isCurrency ? "€" : "")\(String(format: "%.\(floatingPoint)f", value))" + additionalString)
            .font(font ?? .title3)
    }
}

#Preview {
    AnimatedText(value: 300)
}
