//
//  DoubleTapSeek.swift
//  YouTube Video Player
//
//  Created by Matteo Buompastore on 04/01/24.
//

import SwiftUI

struct DoubleTapSeek: View {
    
    // MARK: - PROPERTIES
    var isForward = false
    var onTap: () -> Void
    
    /// Animation
    @State private var isTapped  = false
    @State private var showArrows: [Bool] = [false, false, false]
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .overlay {
                Circle()
                    .fill(.black.opacity(0.4))
                    .scaleEffect(2, anchor: isForward ? .leading : .trailing)
            }
            .clipped()
            .opacity(isTapped ? 1 : 0)
            /// Arrows
            .overlay {
                VStack(spacing: 10) {
                    HStack(spacing: 0) {
                        ForEach((0 ..< showArrows.count).reversed(), id: \.self) { index in
                            Image(systemName: "arrowtriangle.backward.fill")
                                .opacity(showArrows[index] ? 1 : 0.2)
                        } //: LOOP ARROWS
                    } //: HSTACK
                    .font(.title)
                    .rotationEffect(.degrees(isForward ? 180 : 0))
                    
                    Text("\(Int(defaultStandardSeconds)) seconds")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                } //: VSTACK
                /// Showing only when tapped
                .opacity(isTapped ? 1 : 0)
                
            }
            .contentShape(.rect)
            .onTapGesture(count: 2) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isTapped = true
                    showArrows[0] = true
                }
                
                withAnimation(.easeInOut(duration: 0.25).delay(0.2)) {
                    showArrows[0] = false
                    showArrows[1] = true
                }
                
                withAnimation(.easeInOut(duration: 0.25).delay(0.35)) {
                    showArrows[1] = false
                    showArrows[2] = true
                }
                
                withAnimation(.easeInOut(duration: 0.25).delay(0.5)) {
                    showArrows[2] = false
                    isTapped = false
                }
                
                /// Calling on tap
                onTap()
            }
    }
}

#Preview {
    DoubleTapSeek(isForward: true) {}
}
