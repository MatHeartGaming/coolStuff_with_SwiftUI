//
//  TabHostView.swift
//  Playstation App Bar
//
//  Created by Matteo Buompastore on 02/09/24.
//

import SwiftUI

struct TabHostView: View {
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 12) {
                Text("Home")
                    .font(.largeTitle.bold())
                
                ForEach(1...40, id:  \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white.gradient)
                        .frame(height: 45)
                } //: Loop Rectangles
                
            } //: Lazy VSTACK
            .padding(15)
        } //: V-SCROLL
        .safeAreaPadding(.top, 50)
        .safeAreaPadding(.bottom, 120)
    }
    
}

#Preview {
    ContentView()
}
