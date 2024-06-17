//
//  UpdatedScrollPosition.swift
//  New in iOS18
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

/// The scrollPositon modifier now allows more complex stuff like move the scrollView using offset in x and y
struct UpdatedScrollPosition: View {
    var colors: [Color] = [.red, .green, .blue, .yellow, .purple, .cyan, .brown, .black, .indigo]
    @State private var postion: ScrollPosition = .init(idType: Color.self)
    
    var body: some View {
        VStack {
            Button("Move") {
                withAnimation {
                    
                    //postion.scrollTo(y: 550)
                    
                    /// Moves to the end
                    postion.scrollTo(edge: .bottom)
                }
            }
            ScrollView {
                LazyVStack {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(color.gradient)
                            .frame(height: 220)
                    }
                } //: Lazy VSTACK
                .padding(15)
                .scrollTargetLayout()
            } //: V-SCROLL
            .scrollPosition($postion)
        } //: VSTACK
    }

}

#Preview {
    UpdatedScrollPosition()
}
