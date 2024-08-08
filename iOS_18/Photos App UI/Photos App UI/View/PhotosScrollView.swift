//
//  PhotosScrollView.swift
//  Photos App UI
//
//  Created by Matteo Buompastore on 08/08/24.
//

import SwiftUI

struct PhotosScrollView: View {
    
    // MARK: Properties
    var size: CGSize
    var safeArea: EdgeInsets
    @Environment(SharedData.self) private var sharedData
    
    /// Photos ScrollVIew Position
    @State private var scrollPosition: ScrollPosition = .init()
    
    var body: some View {
        let screenHeight = size.height + safeArea.top + safeArea.bottom
        let minimisedHeight = screenHeight * 0.4
        ScrollView(.horizontal) {
            LazyHStack(alignment: .bottom, spacing: 0) {
                GridPhotosScrollView()
                    /// You can use .containerRelativeFrame as well
                    .frame(width: size.width)
                    //.containerRelativeFrame(.horizontal)
                    .id(1)
                
                Group {
                    StretchableView(.blue)
                        .id(2)
                    
                    StretchableView(.yellow)
                        .id(3)
                    
                    StretchableView(.purple)
                        .id(4)
                } //: Stretchable GROUP
                .frame(height: screenHeight - minimisedHeight)
            } //: Lazy HSTACK
            /// Spacing for indicator
            .padding(.bottom, safeArea.bottom + 20)
            .scrollTargetLayout()
        } //: H-SCROLL
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .offset(y: sharedData.canPullUp ? sharedData.photosScrollOffset : 0)
        .scrollPosition(id: .init(get: {
            return sharedData.activePage
        }, set: {
            if let newValue = $0 {
                sharedData.activePage = newValue
            }
        }))
        /// Disabling the Horizontal scroll interaction when the Photos Grid is expanded
        .scrollDisabled(sharedData.isExpanded)
        .frame(height: screenHeight)
        .frame(
            height: screenHeight - (minimisedHeight - (minimisedHeight * sharedData.progress)), alignment: .bottom)
        .overlay(alignment: .bottom) {
            CustomPagingIndicatorView {
                Task {
                    /// First check if photos View is Scrolled
                    if sharedData.photosScrollOffset != 0 {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            scrollPosition.scrollTo(edge: .bottom)
                        }
                        try? await Task.sleep(for: .seconds(0.13))
                        
                        /// Minimise
                        withAnimation(.easeInOut(duration: 0.25)) {
                            sharedData.progress = 0
                            sharedData.isExpanded = false
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func GridPhotosScrollView() -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: 3)) {
                ForEach(0...300, id: \.self) { _ in
                    Rectangle()
                        .fill(.red)
                        .frame(height: 120)
                } //: Loop
            } //: Lazy V-GRID
            .scrollTargetLayout()
            .offset(y: sharedData.progress * -(safeArea.bottom + 20))
        } //: V-SCROLL
        .defaultScrollAnchor(.bottom)
        .scrollDisabled(!sharedData.isExpanded)
        .scrollPosition($scrollPosition)
        .scrollClipDisabled()
        .onScrollGeometryChange(for: CGFloat.self, of: { proxy in
            /// This will be zero then the content is placed at the bottom
            proxy.contentOffset.y - proxy.contentSize.height + proxy.containerSize.height
        }, action: { oldValue, newValue in
            sharedData.photosScrollOffset = newValue
        })
    }
    
    /// Stretchable Paging Views
    @ViewBuilder
    private func StretchableView(_ color: Color) -> some View {
        GeometryReader {
            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
            let size = $0.size
            Rectangle()
                .fill(color)
                .frame(width: size.width,
                       height: size.height + (minY > 0 ? minY : 0))
                .offset(y: (minY > 0 ? -minY : 0))
        } //: GEOMETRY
        .frame(width: size.width)
    }
    
}

#Preview {
    GeometryReader {
        let size = $0.size
        let safeArea = $0.safeAreaInsets
        PhotosScrollView(size: size, safeArea: safeArea)
    }
    .environment(SharedData())
}

#Preview("ContentView") {
    ContentView()
}
