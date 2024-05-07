//
//  Home.swift
//  Pinterest Grid Animation
//
//  Created by Matteo Buompastore on 07/05/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - Properties
    var coordinator: UICoordinator = .init()
    @State private var posts: [Item] = sampleImages
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 15) {
                Text("Welcome Back!")
                    .font(.largeTitle.bold())
                    .padding(.vertical, 10)
                
                /// Grid Image View
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
                    ForEach(posts) { post in
                        PostCardView(post)
                    }
                    
                } //: Lazy V-GRID
                
            } //: Lazy VSTACK
            .padding(15)
            .background(ScrollViewExtractor {
                coordinator.scrollView = $0
            })
            
        } //: SCROLL
        .overlay {
            Detail()
                .environment(coordinator)
            /*if let animationLayer = coordinator.animationLayer {
                Image(uiImage: animationLayer)
                    .ignoresSafeArea()
                    .opacity(0.5)
            }*/
        }
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    private func PostCardView(_ post: Item) -> some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            if let image = post.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: frame.width, height: frame.height)
                    .clipShape(.rect(cornerRadius: 10))
                    .contentShape(.rect(cornerRadius: 10))
                    .onTapGesture {
                        /// Storing View's Rect
                        coordinator.rect = frame
                        /// Generating ScrollView's Visible area Snapshot
                        coordinator.createVisibleAreaSnapshot()
                    }
            }
            
        } //: GEOMETRY
        .frame(height: 180)
    }
}

#Preview {
    Home()
}
