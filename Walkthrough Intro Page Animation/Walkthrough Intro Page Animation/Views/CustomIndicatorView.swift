//
//  CustomIndicatorView.swift
//  Walkthrough Intro Page Animation
//
//  Created by Matteo Buompastore on 16/02/24.
//

import SwiftUI

struct CustomIndicatorView: View {
    
    //MARK: - Propeties
    var totalPages: Int
    var currentPage: Int
    var activeTint: Color = .black
    var inactiveTint: Color = .gray.opacity(0.5)
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? activeTint : inactiveTint)
                    .frame(width: 4, height: 4)
            } //: Loop Pages
        } //: HSTACK
    }
}

#Preview {
    CustomIndicatorView(totalPages: 3, currentPage: 1)
}
