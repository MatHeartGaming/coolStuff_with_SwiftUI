//
//  LoopingStack.swift
//  Stacked Loopinig Cards
//
//  Created by Matteo Buompastore on 24/01/25.
//

import SwiftUI

struct LoopingStack<Content: View>: View {
    
    // MARK: Properties
    var visibleCardsCount: Int = 2
    var maxTranslationWidth: CGFloat?
    @ViewBuilder var content: Content
    
    /// UI
    @State private var rotation: Int = 0
    
    var body: some View {
        /// With iOS 18 we can extract Subview collection from a view content using Group
        Group(subviews: content) { collection in
            let collection = collection.rotateFromLeft(by: rotation)
            let count = collection.count
            
            ZStack {
                ForEach(collection) { view in
                    /// Let's reverse the stack using ZIndex
                    let index = collection.index(view)
                    let zIndex = Double(count - index)
                    
                    LoopingStackCardView(
                        index: index,
                        count: count,
                        visibleCardsCount: visibleCardsCount,
                        rotation: $rotation,
                        maxTranslationWidth: maxTranslationWidth) {
                        view
                    }
                    .zIndex(zIndex)
                    
                } //: Loop Collection
            } //: ZSTACK
            
        } //: Group
    }
}

/// Custom View for each Card, so it maintain the offset individually
fileprivate struct LoopingStackCardView<Content: View>: View {
    
    var index: Int
    var count: Int
    var visibleCardsCount: Int
    @Binding var rotation: Int
    var maxTranslationWidth: CGFloat?
    @ViewBuilder var content: Content
    
    /// Interaction
    @State private var offset: CGFloat = .zero
    /// To calculate the end result when drag is finished (to push the next card)
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        /// Visible Cards Offset and Scaling
        let extraOffset = min(CGFloat(index) * 20, CGFloat(visibleCardsCount) * 20)
        let scale = 1 - min(CGFloat(index) * 0.07, CGFloat(visibleCardsCount) * 0.07)
        
        /// 3D rotation
        let rotationDegree: CGFloat = -30
        let rotation = max(min(-offset / viewSize.width, 1), 0) * rotationDegree
        
        content
            .onGeometryChange(for: CGSize.self, of: {
                $0.size
            }, action: {
                viewSize = $0
            })
            .offset(x: extraOffset)
            .scaleEffect(scale, anchor: .trailing)
            /// Let's animate the index effects
            .animation(.smooth(duration: 0.25, extraBounce: 0), value: index)
            .offset(x: offset)
            .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0), anchor: .center, perspective: 0.5)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        /// Only allows left side interactions
                        let xOffset = -max(-value.translation.width, 0)
                        if let maxTranslationWidth {
                            let progress = -max(min(-xOffset / maxTranslationWidth, 1), 0) * viewSize.width
                            offset = progress
                        } else {
                            offset = xOffset
                        }
                    }.onEnded { value in
                        let xVelocity = max(-value.velocity.width / 5, 0)
                        
                        if (-offset + xVelocity) > (viewSize.width * 0.65) {
                            pushToNextCard()
                        } else {
                            withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                                offset = .zero
                            }
                        }
                    },
                /// Only enabling gesture for top most card
                isEnabled: index == 0 && count > 1
            )
    }
    
    
    private func pushToNextCard() {
        /// We need to avoid the zIndex effect of cards transpassing each other
        withAnimation(.smooth(duration: 0.25, extraBounce: 0).logicallyComplete(after: 0.15), completionCriteria: .logicallyComplete) {
            offset = -viewSize.width
        } completion: {
            /// Update zIndex after the card has been moved and reset the offset value
            rotation += 1
            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                offset = .zero
            }
            
        }
    }
    
}

extension SubviewsCollection {
    
    /// Now, to simulate cards being placed at the bottom of the deck and appear to be looping
    /// we can rotate the array
    
    func rotateFromLeft(by: Int) -> [SubviewsCollection.Element] {
        guard !isEmpty else {
            return []
        }
        let moveIndex = by % count
        let rotatedElements = Array(self[moveIndex...] + Array(self[0...moveIndex]))
        return rotatedElements
    }
}

extension [SubviewsCollection.Element] {
    func index(_ item: SubviewsCollection.Element) -> Int {
        firstIndex(where: { $0.id == item.id }) ?? 0
    }
}

#Preview {
    ContentView()
}
