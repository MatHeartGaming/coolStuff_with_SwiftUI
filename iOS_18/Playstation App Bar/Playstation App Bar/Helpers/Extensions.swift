//
//  Extensions.swift
//  Playstation App Bar
//
//  Created by Matteo Buompastore on 18/01/24.
//

import SwiftUI

extension View {
    
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    
}


/// Glow Custom View Extension
extension View {
    
    func glow(_ color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5) 
    }
    
}
