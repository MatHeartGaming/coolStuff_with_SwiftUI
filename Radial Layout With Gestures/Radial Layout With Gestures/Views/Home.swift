//
//  Home.swift
//  Radial Layout With Gestures
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

struct Home: View {
    
    //MARK: - VIEW PROPERTIES
    @State private var colors: [ColorValue] = [
        Color.red, .yellow, .green, .purple, .pink, .orange, .brown, .cyan, .indigo, .mint
    ].compactMap { color in
        return ColorValue(color: color)
    }
    
    @State private var activeIndex: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 0)
                
                RadialLayout(item: colors, id: \.id, spacing: 200) { colorValue, index, size in
                    /// Sample View
                    Circle()
                        .fill(colorValue.color.gradient)
                        .overlay {
                            Text("\(index)")
                                .fontWeight(.semibold)
                        }
                } onIndexChange: { index in
                    self.activeIndex = index
                }
                .padding(.horizontal, -100)
                .frame(width: geometry.size.width, height: geometry.size.width / 3)

            } //: VSTACK
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } //: GEOMETRY
        .padding(15)
    }
}

#Preview {
    Home()
}
