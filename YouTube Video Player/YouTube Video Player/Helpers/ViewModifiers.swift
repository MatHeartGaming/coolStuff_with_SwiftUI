//
//  ViewModifiers.swift
//  YouTube Video Player
//
//  Created by Matteo Buompastore on 04/01/24.
//

import Foundation
import SwiftUI

struct VideoPlayerIconStyle: ViewModifier {
    
    
    var fontSize: CGFloat = 14
    var fontWeight: Font.Weight = .ultraLight
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: fontWeight, design: .rounded))
            .foregroundColor(.white)
            .padding(15)
            .background(Circle().fill(.black.opacity(0.35)))
        
    }
    
}
