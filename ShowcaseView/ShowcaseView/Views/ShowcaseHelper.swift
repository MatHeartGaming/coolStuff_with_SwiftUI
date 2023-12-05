//
//  ShowcaseHelper.swift
//  ShowcaseView
//
//  Created by Matteo Buompastore on 05/12/23.
//

import SwiftUI

/// Showcase Root View Controller
struct ShowcaseRoot: ViewModifier {
    
    var showHighlights: Bool
    var onFinished: () -> Void
    
    // MARK: - UI
    @State private var highlightOrder: [Int] = []
    @State private var currentHighlight: Int = 0
    /// Popover
    @State private var showTitle: Bool = false
    /// Namespace ID, for smooth shape transitions
    @Namespace private var animation
    @State private var showView = true
    
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(HighlightAnchorKey.self, perform: { value in
                highlightOrder = Array(value.keys).sorted()
            })
            .overlayPreferenceValue(HighlightAnchorKey.self, { preferences in
                if highlightOrder.indices.contains(currentHighlight), showHighlights, showView {
                    if let highlight = preferences[highlightOrder[currentHighlight]] {
                        HighlightView(highlight)
                    }
                }
            })
    }
    
    /// Highlight View
    @ViewBuilder
    func HighlightView(_ highlight: Highlight) -> some View {
        /// Geometry Reader for extracting highlight ftame rects
        GeometryReader { geometry in
            let highlightRect = geometry[highlight.anchor]
            let safeArea = geometry.safeAreaInsets
            
            Rectangle()
                .fill(.black.opacity(0.5))
                .reverseMask{
                    Rectangle()
                        .matchedGeometryEffect(id: "HIGHLIGHT_SHAPE", in: animation)
                        /// Adding border
                        .frame(width: highlightRect.width + 5, height: highlightRect.height + 5)
                        .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                        .scaleEffect(highlight.scale)
                        .offset(x: highlightRect.minX - 2.5, y: highlightRect.minY + safeArea.top - 2.5)
                }
                .ignoresSafeArea()
                .onTapGesture {
                    if currentHighlight >= highlightOrder.count - 1 {
                        /// Hiding the Highlight View because it was the last
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showView = false
                        }
                        onFinished()
                    } else {
                        /// Moving to next highlight
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                            showTitle = false
                            currentHighlight += 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            showTitle = true
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showTitle = true
                    }
                }
            
            Rectangle()
                .foregroundStyle(.clear)
                /// Adding border
                .frame(width: highlightRect.width + 20, height: highlightRect.height + 20)
                .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                .popover(isPresented: $showTitle) {
                    Text(highlight.title)
                        .padding(.horizontal, 10)
                        .presentationCompactAdaptation(.popover)
                        .interactiveDismissDisabled()
                } //: POPOVER
                .scaleEffect(highlight.scale)
                .offset(x: highlightRect.minX - 10, y: highlightRect.minY - 10)
            
        } //: GEOMETRY
        
    }
    
}

#Preview {
    ContentView()
}
