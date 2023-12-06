//
//  GradientButton.swift
//  LoginSignupView
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct GradientButton: View {
    
    //MARK: - UI
    var title: String
    var icon: String
    var onClick: () -> Void
    
    
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15) {
                Text(title)
                
                Image(systemName: icon)
            } //: HSTACK
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(.linearGradient(
                colors: [.appYellow, .orange, .red],
                startPoint: .top, 
                endPoint: .bottom),
                in: .capsule
            )
        })
    }
}

@available(iOS 17, *)
#Preview(traits: .sizeThatFitsLayout) {
    GradientButton(title: "Press Me", icon: "lock", onClick: {})
}
