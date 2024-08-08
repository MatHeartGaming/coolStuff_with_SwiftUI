//
//  Home.swift
//  Photos App UI
//
//  Created by Matteo Buompastore on 08/08/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: Properties
    var size: CGSize
    var safeArea: EdgeInsets
    var sharedData = SharedData()
    
    var body: some View {
        let minimisedHeight = (size.height + safeArea.top + safeArea.bottom) * 0.4
        let mainOffset = sharedData.mainOffset
        ScrollView(.vertical) {
            VStack(spacing: 10) {
                PhotosScrollView(size: size, safeArea: safeArea)
                
                /// Other Bottom content (Albums, People ... )
                OtherContents()
                    .padding(.top, -30)
                    .offset(y: sharedData.progress * 30)
                
            } //: VSTACK
            .offset(y: sharedData.canPullDown ? 0 : mainOffset < 0 ? -mainOffset : 0)
            .offset(y: mainOffset < 0 ? mainOffset : 0)
        } //: SCROLL
        .onScrollGeometryChange(for: CGFloat.self, of: { proxy in
            proxy.contentOffset.y
        }, action: { oldValue, newValue in
            sharedData.mainOffset = newValue
        })
        /// Disabling main ScrollView ineraction if Photos grid is expanded
        .scrollDisabled(sharedData.isExpanded)
        .environment(sharedData)
        .gesture(
            /// Making this gesture only work when the Photos Grid ScollView is visible
            CustomGesture(isEnabled: sharedData.activePage == 1) { gesture in
                let state = gesture.state
                let translation = gesture.translation(in: gesture.view).y
                let isScrolling = state == .began || state == .changed
                
                if state == .began {
                    sharedData.canPullDown = translation > 0 && sharedData.mainOffset == 0
                    sharedData.canPullUp = translation < 0 && sharedData.photosScrollOffset == 0
                }
                
                if isScrolling {
                    /// Like onChange modifier in Drag Gesture
                    if sharedData.canPullDown && !sharedData.isExpanded {
                        let progress = max(min(translation / minimisedHeight, 1), 0)
                        sharedData.progress = progress
                    }
                    
                    if sharedData.canPullUp && sharedData.isExpanded {
                        let progress = max(min(-translation / minimisedHeight, 1), 0)
                        sharedData.progress = 1 - progress
                    }
                } else {
                    /// Like onEnded
                    withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                        if sharedData.canPullDown && !sharedData.isExpanded {
                            if translation > 0 {
                                sharedData.isExpanded = true
                                sharedData.progress = 1
                            }
                        }
                        
                        if sharedData.canPullUp && sharedData.isExpanded {
                            if translation < 0 {
                                sharedData.isExpanded = false
                                sharedData.progress = 0
                            }
                        }
                    }
                }
            }
        ) //: Gesture
        .background(.gray.opacity(0.05))
    }
}

#Preview {
    ContentView()
}
