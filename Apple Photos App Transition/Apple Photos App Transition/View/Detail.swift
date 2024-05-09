//
//  Detail.swift
//  Apple Photos App Transition
//
//  Created by Matteo Buompastore on 09/05/24.
//

import SwiftUI

struct Detail: View {
    
    @Environment(UICoordinator.self) private var coordinator
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(coordinator.items) { item in
                        ImageView(item, size: size)
                    } //: Loop Items
                } //: Lazy H-STACK
                .scrollTargetLayout()
            } //: H-SCROLL
            /// Making it a paging virew
            .scrollTargetBehavior(.paging)
        } //: GEOMETRY
        .opacity(coordinator.showDetailView ? 1 : 0 )
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    private func ImageView(_ item: Item, size: CGSize) -> some View {
        if let image = item.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                .clipped()
                .contentShape(.rect)
        }
    }
    
}

#Preview {
    Detail()
        .environment(UICoordinator())
}

#Preview {
    ContentView()
}
