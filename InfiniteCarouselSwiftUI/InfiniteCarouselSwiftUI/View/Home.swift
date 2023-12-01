//
//  Home.swift
//  InfiniteCarouselSwiftUI
//
//  Created by Matteo Buompastore on 30/11/23.
//

import SwiftUI

struct Home: View {
    
    //MARK: - PROPERTIES
    @State private var items: [Item] = previewItems
    
    var body: some View {
        let width: CGFloat = 150
        ScrollView(.vertical) {
            VStack {
                GeometryReader { geom in
                    
                    let size = geom.size
                    
                    LoopingScrollView(width: size.width, spacing: 0, items: items) { item in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.color.gradient)
                            .padding(.horizontal, 15)
                    }
                    //.contentMargins(.horizontal, 15, for: .scrollContent)
                    .scrollTargetBehavior(.paging)
                }
                .frame(height: width)
                
            } //: VSTACK
            .padding(.vertical, 15)
        } //: ScrollView
        .scrollIndicators(.hidden)
    }
}

#Preview {
    Home()
}
