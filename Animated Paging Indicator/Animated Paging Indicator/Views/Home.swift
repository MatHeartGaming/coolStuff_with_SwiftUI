//
//  Home.swift
//  Animated Paging Indicator
//
//  Created by Matteo Buompastore on 02/01/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - UI
    @State private var colors: [Color] = [.red, .blue, .green, .yellow]
    @State private var opacityEffect: Bool = false
    @State private var clipEdges: Bool = false
    
    var body: some View {
        VStack {
            /// Paging View
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 25)
                            .fill(color.gradient)
                            .padding(.horizontal, 5)
                            .containerRelativeFrame(.horizontal)
                    } //: LOOP COLORS
                } //: LAZY HSTACK
                .scrollTargetLayout() /// Comment to have standrd Paging behaviour
                .overlay(alignment: .bottom) {
                    PagingIndicator(
                        activeTint: .white,
                        inactiveTint: .black.opacity(0.25),
                        opacityEffect: opacityEffect,
                        clipEdges: clipEdges
                    )
                }
            } //: SCROLL
            .scrollIndicators(.hidden)
            .frame(height: 220)
            /// Uncomment these two lines to have the standard paging
            //.padding(.top, 15)
            //.scrollTargetBehavior(.paging)
            .safeAreaPadding(.vertical, 15)
            .safeAreaPadding(.horizontal, 25)
            .scrollTargetBehavior(.viewAligned)
            
            List {
                Section("Options") {
                    Toggle("Opacity Effect", isOn: $opacityEffect)
                    Toggle("Clip Edges", isOn: $clipEdges)
                    
                    Button("Add Item") {
                        if !colors.contains(.purple) {
                            colors.append(.purple)
                        }
                    }
                }
            } //: LIST
            .clipShape(.rect(cornerRadius: 15))
            .padding(15)
            
        } //: VSTACK
        .navigationTitle("Custom Indicator")
    }
}

extension View {
    
    func toSnapCarousel(verticalPadding: CGFloat = 15, horizontalPadding: CGFloat = 25) -> some View {
        self
            .safeAreaPadding(.vertical, verticalPadding)
            .safeAreaPadding(.horizontal, horizontalPadding)
            .scrollTargetBehavior(.viewAligned)
    }
    
}

struct SnapCarousel: ViewModifier {
    
    var paddingTop: CGFloat = 15
    
    func body(content: Content) -> some View {
        content
            .padding(.top, paddingTop)
            .scrollTargetBehavior(.paging)
    }
}

struct StandardPager: ViewModifier {
    
    var verticalPadding: CGFloat = 15
    var horizontalPadding: CGFloat = 25
    
    func body(content: Content) -> some View {
        content
            .safeAreaPadding(.vertical, verticalPadding)
            .safeAreaPadding(.horizontal, horizontalPadding)
            .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    Home()
}
