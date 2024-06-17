//
//  OnScrollGestureChange.swift
//  New in iOS18
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

/// Tells us wheter a given view is in the visible screen area
struct ScrollVisibilityChange: View {
    
    var colors: [Color] = [.red, .green, .blue, .yellow, .purple, .cyan, .brown, .black, .indigo]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(color.gradient)
                            .containerRelativeFrame(.vertical)
                            /// Top is 0, bottom is 1. Useful for pausing video reproduction in reels.
                            .onScrollVisibilityChange(threshold: 0.5) { status in
                                if status {
                                    print("\(color) is visible")
                                }
                            }
                    }
                } //: Lazy VSTACK
                .padding(15)
                .scrollTargetLayout()
            } //: V-SCROLL
            .scrollTargetBehavior(.viewAligned)
        } //: VSTACK

    }
}

#Preview {
    ScrollVisibilityChange()
}
