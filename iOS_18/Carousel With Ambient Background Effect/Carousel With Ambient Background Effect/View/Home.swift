//
//  Home.swift
//  Carousel With Ambient Background Effect
//
//  Created by Matteo Buompastore on 16/01/25.
//

import SwiftUI

struct Home: View {
    
    // MARK: Properties
    @State private var topInset: CGFloat = 0
    @State private var scrollOffsetY: CGFloat = 0
    @State private var scrollProgressX: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                HeaderView()
                
                CarouselView()
                    /// To avoid hiding the Header
                    .zIndex(-1)
                
            } //: Lazy VSTACK
        } //: V-SCROLL
        .safeAreaPadding(15)
        /// Gradient Background
        .background {
            Rectangle()
                .fill(.black.gradient)
                .scaleEffect(y: -1)
                .ignoresSafeArea()
        }
        .onScrollGeometryChange(for: ScrollGeometry.self) { geo in
            geo
        } action: { oldValue, newValue in
            /// 100 is the approximate value of the header view
            topInset = newValue.contentInsets.top + 100
            
            /// Sticky Header
            scrollOffsetY = newValue.contentOffset.y + newValue.contentInsets.top
        }

    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func CarouselView() -> some View {
        let spacing: CGFloat = 6
        ScrollView(.horizontal) {
            HStack(spacing: spacing) {
                ForEach(images) { model in
                    Image(model.image)
                        .resizable()
                        .scaledToFill()
                        .containerRelativeFrame(.horizontal)
                        .frame(height: 380)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                    
                } //: Loop Images
            } // HSTACK
            .scrollTargetLayout()
        } //: H-SCROLL
        .frame(height: 380)
        .background(BackdropCarouselView())
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .onScrollGeometryChange(for: CGFloat.self) {
            let offsetX = $0.contentOffset.x + $0.contentInsets.leading
            let width = $0.containerSize.width + spacing
            return offsetX / width
        } action: { oldValue, newValue in
            let maxValue = CGFloat(images.count - 1)
            scrollProgressX = min(max(newValue, 0), maxValue)
        }

    }
    
    private func HeaderView() -> some View {
        HStack {
            Image(systemName: "xbox.logo")
                .font(.system(size: 35))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Leon S. Kennedy")
                    .font(.callout)
                    .fontWeight(.semibold)
                
                HStack(spacing: 6) {
                    Image(systemName: "g.circle.fill")
                    
                    Text("€49.89")
                        .font(.caption)
                    
                } //: HSTACK
                
            } //: VSTACK
            
            Spacer(minLength: 0)
            
            Image(systemName: "square.and.arrow.up.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white, .fill)
            
            Image(systemName: "bell.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white, .fill)
                
            
        } //: HSTACK
        .padding(.bottom, 15)
    }
    
    @ViewBuilder
    private func BackdropCarouselView() -> some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                ForEach(images.reversed()) { model in
                    let index = CGFloat(images.firstIndex(where: { $0.id == model.id }) ?? 0) + 1
                    Image(model.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .opacity(index - scrollProgressX)
                } //: Loop
            } //: ZSTACK
            .compositingGroup()
            .blur(radius: 30, opaque: true)
            .overlay {
                Rectangle()
                    .fill(.black.opacity(0.35))
            }
            /// Progressive Masking
            .mask {
                Rectangle()
                    .fill(
                        .linearGradient(colors: [
                            .black,
                            .black,
                            .black,
                            .black,
                            .black.opacity(0.5),
                            .clear
                        ], startPoint: .top, endPoint: .bottom)
                    )
            }
        } //: GEOMETRY
        .containerRelativeFrame(.horizontal)
        /// Extending bottom side to enhance progressive effect
        .padding(.bottom, -60)
        .padding(.top, -topInset)
        /// Sticky Header
        .offset(y: scrollOffsetY < 0 ? scrollOffsetY : 0)
    }
}

#Preview {
    ContentView()
}
