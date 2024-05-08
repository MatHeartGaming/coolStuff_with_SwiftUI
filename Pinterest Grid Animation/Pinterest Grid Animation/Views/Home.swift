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
        .opacity(coordinator.hideRootView ? 0 : 1)
        .scrollDisabled(coordinator.hideRootView)
        .allowsHitTesting(!coordinator.hideRootView)
        .overlay {
            Detail()
                .environment(coordinator)
                .allowsHitTesting(coordinator.hideLayer)
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
            
            ImageView(post: post)
                .clipShape(.rect(cornerRadius: 10))
                .contentShape(.rect(cornerRadius: 10))
                .onTapGesture {
                    coordinator.toggleView(show: true, frame: frame, post: post)
                }
        } //: GEOMETRY
        .frame(height: 180)
    }
}

#Preview {
    Home()
}
