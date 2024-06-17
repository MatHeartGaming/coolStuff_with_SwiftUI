//
//  OnScrollGestureChange.swift
//  New in iOS18
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

/// We can now read scroll offsets, content size, and more directly without the need for PreferenceKeys
struct OnScrollGestureChange: View {
    
    var colors: [Color] = [.red, .green, .blue, .yellow, .purple, .cyan, .brown, .black, .indigo]
    @State private var offset: CGFloat = 0
    @State private var isScrolling: Bool = false
    
    var body: some View {
        VStack {
            Text("Scroll Offset = \(offset) - \(isScrolling ? "Scrolling" : "Idle")")
            ScrollView {
                LazyVStack {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(color.gradient)
                            .frame(height: 220)
                    }
                } //: Lazy VSTACK
                .padding(15)
            } //: V-SCROLL
            .onScrollPhaseChange({ oldPhase, newPhase in
                isScrolling = newPhase.isScrolling
            })
            .onScrollGeometryChange(for: CGFloat.self) { proxy in
                return proxy.contentOffset.y
            } action: { oldValue, newValue in
                offset = newValue
            }
            .onScrollGeometryChange(for: Bool.self) { proxy in
                return proxy.contentOffset.y > 200
            } action: { oldValue, newValue in
                if newValue {
                    print("First card moved away")
                }
            }
        } //: VSTACK

    }
}

#Preview {
    OnScrollGestureChange()
}
