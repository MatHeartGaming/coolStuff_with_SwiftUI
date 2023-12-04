//
//  RadialView.swift
//  Radial Layout With Gestures
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

struct RadialLayout<Content: View, Item: RandomAccessCollection, ID: Hashable>: View where Item.Element: Identifiable {
    
    //MARK: - PROPERTIES
    /// Returning also index and View size
    var content: (Item.Element, Int, CGFloat) -> Content
    var keyPathId: KeyPath<Item.Element, ID>
    var items: Item
    
    //MARK: - UI
    var spacing: CGFloat?
    var onIndexChange: (Int) -> ()
    
    init(item: Item, id: KeyPath<Item.Element, ID>, spacing: CGFloat? = nil, @ViewBuilder content: @escaping (Item.Element, Int, CGFloat) -> Content, onIndexChange: @escaping (Int) -> ()) {
        self.content = content
        self.onIndexChange = onIndexChange
        self.spacing = spacing
        self.keyPathId = id
        self.items = item
    }
    
    //MARK: - GESTURE PROPERTIES
    @State private var dragRotation: Angle = .zero
    @State private var lastDragRotation: Angle = .zero
    @State private var activeIndex: Int = 0
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let width = size.width
            let count = CGFloat(items.count)
            /// Applying spacing
            let spacing: CGFloat = spacing ?? 0
            /// View size in the radial layout is calculated by the total count
            let viewSize = (width - spacing) / (count / 2)
            
            
            ZStack {
                ForEach(items, id: keyPathId) { item in
                    
                    let index = fetchIndex(item)
                    let rotation = (CGFloat(index) / count) * 360.0
                    
                    content(item, index, viewSize)
                        .rotationEffect(.degrees(90))
                        .rotationEffect(.degrees(-rotation))
                        .rotationEffect(-dragRotation)
                        .frame(width: viewSize, height: viewSize)
                        /// Building radial layout
                        .offset(x: (width - viewSize) / 2)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(rotation))
                        
                        
                } //: LOOP
            } //: ZSTACK
            .frame(width: width, height: width)
            /// Gesture
            .contentShape(.rect)
            .rotationEffect(dragRotation)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationX = value.translation.width
                        let progress = translationX / (viewSize * 2)
                        let rotationFraction = 360.0 / count
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.6)) {
                            dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                        }
                    }).onEnded({ value in
                        let velocityX = value.velocity.width / 15
                        let translationX = value.translation.width + velocityX
                        let progress = (translationX / (viewSize * 2)).rounded()
                        let rotationFraction = 360.0 / count
                        withAnimation(.smooth) {
                            dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                            lastDragRotation = dragRotation
                            calculateCenterIndex(count)
                        }
                    })
            )
        })
    }
    
    // MARK: - FUNCTIONS
    func calculateCenterIndex(_ count: CGFloat) {
        var activeIndex = (dragRotation.degrees / 360.0 * count).rounded()
            .truncatingRemainder(dividingBy: count)
        activeIndex = activeIndex == 0 ? 0 : (activeIndex < 0 ? -activeIndex : count - activeIndex)
        self.activeIndex = Int(activeIndex)
        /// Notify the view
        onIndexChange(self.activeIndex)
    }
    
    func fetchIndex(_ item: Item.Element) -> Int {
        if let index = items.firstIndex(where: {$0.id == item.id}) as? Int {
            return index
        }
        return 0
    }
    
}

#Preview {
    ContentView()
}
