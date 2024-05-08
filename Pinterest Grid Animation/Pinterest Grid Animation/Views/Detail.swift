//
//  Detail.swift
//  Pinterest Grid Animation
//
//  Created by Matteo Buompastore on 07/05/24.
//

import SwiftUI

struct Detail: View {
    
    //MARK: - Properties
    @Environment(UICoordinator.self) private var coordinator
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let animateView = coordinator.animateView
            let hideLayer = coordinator.hideLayer
            let rect = coordinator.rect
            /// if the anchor is less than 0.5 it is on the leading side, otherrwise on the trailing side. This only works for 2 columns.
            let anchorX: CGFloat = (rect.minX / size.width) > 0.5 ? 1 : 0
            let scale =  size.width / rect.width
            
            let offsetX = animateView ? (anchorX > 0.5 ? 15 : -15) * scale : 0
            let offsetY = animateView ? -rect.minY * scale : 0
            
            let detailheight: CGFloat = rect.height * scale
            let scrollContentHeight: CGFloat = size.height - detailheight
            
            /// 15 - Horizontal Padding
            if let image = coordinator.animationLayer, let post = coordinator.selectedItem {
                if !hideLayer {
                    Image(uiImage: image)
                        .scaleEffect(animateView ? scale : 1,
                                     anchor: .init(x: anchorX, y: 0))
                        .offset(x: offsetX, y: offsetY)
                        .offset(y: animateView ? -coordinator.headerOffset : 0)
                        .opacity(animateView ? 0 : 1)
                        .transition(.identity)
                        /*.onTapGesture {
                            /// For testing
                            coordinator.animationLayer = nil
                            coordinator.hideRootView = false
                            coordinator.animateView = false
                        }*/
                }
                
                ScrollView(.vertical) {
                    
                    ScrollViewContent()
                        .safeAreaInset(edge: .top) {
                            Rectangle()
                                .fill(.clear)
                                .frame(height: detailheight)
                                .offsetY { offset in
                                    coordinator.headerOffset = max(min(-offset, detailheight), 0)
                                }
                        }
                    
                } //: V-SCROLL
                .scrollDisabled(!hideLayer)
                .contentMargins(.top, detailheight, for: .scrollIndicators)
                .background {
                    Rectangle()
                        .fill(.background)
                        .padding(.top, detailheight)
                }
                .animation(.easeInOut(duration: 0.3).speed(1.5)) {
                    $0
                        .offset(y: animateView ? 0 : scrollContentHeight)
                        .opacity(animateView ? 1 : 0)
                }
                
                /// HERO-like View
                ImageView(post: post)
                    .allowsHitTesting(false)
                    .frame(width: animateView ? size.width : rect.width,
                           height: animateView ? rect.height * scale : rect.height)
                    .clipShape(.rect(cornerRadius: animateView ? 0 : 10))
                    .overlay(alignment: .top) {
                        HeaderActions(post)
                            .offset(y: coordinator.headerOffset)
                            .padding(.top, safeArea.top)
                    }
                    .offset(x: animateView ? 0 : rect.minX, y: animateView ? 0 : rect.minY)
                    .offset(y: animateView ? -coordinator.headerOffset : 0)
                
            }
        } //: GEOMETRY
        .ignoresSafeArea()
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func ScrollViewContent() -> some View {
        DummyContent()
    }
    
    @ViewBuilder
    private func HeaderActions(_ post: Item) -> some View {
        HStack {
            Spacer(minLength: 0)
            
            Button(action: {
                coordinator.toggleView(show: false, frame: .zero, post: post)
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.primary, .bar)
                    .padding(10)
                    .contentShape(.rect)
            })
            
        } //: HSTACK
        .animation(.easeInOut(duration: 0.3)) {
            $0
                .opacity(coordinator.hideLayer ? 1 : 0)
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
