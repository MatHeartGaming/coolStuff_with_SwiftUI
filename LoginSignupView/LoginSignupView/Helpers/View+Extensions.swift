//
//  View+Extensions.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI


extension View {
    
    /// View Alignments
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// Disable with opacity
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.5: 1)
    }
    
}
