//
//  LoopingScrollView.swift
//  InfiniteCarouselSwiftUI
//
//  Created by Matteo Buompastore on 30/11/23.
//

import SwiftUI

struct LoopingScrollView<Content: View, Items: RandomAccessCollection>: View where Items.Element: Identifiable {
    
    /// Customization properties
    var width: CGFloat
    var spacing: CGFloat
    
    //MARK: - PROPERTIES
    var items: Items
    @ViewBuilder var content: (Items.Element) -> Content
    
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            /// Safety check
            let repeatingCount = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: spacing) {
                    
                    ForEach(items) { item in
                        content(item)
                            .frame(width: width)
                    } //: LOOP
                    
                    ForEach(0..<repeatingCount, id: \.self) { index in
                        let item = Array(items)[index % items.count]
                        content(item)
                            .frame(width: width)
                        
                    } //: LOOP
                } //: LazyHStack
                .background(
                    ScrollViewHelper(width: width,
                                     spacing: spacing,
                                     itemCount: items.count,
                                     repeatingCount: repeatingCount
                                    )
                )
                
            } //: SCROLL
            .scrollIndicators(.hidden)
            
        } //: GEOMETRY
    }
}

fileprivate struct ScrollViewHelper: UIViewRepresentable {
    
    var width: CGFloat
    var spacing: CGFloat
    var itemCount: Int
    var repeatingCount: Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(width: width,
                           spacing: spacing,
                           itemCount: itemCount,
                           repeatingCount: repeatingCount
        )
    }
    
    func makeUIView(context: Context) -> some UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let scrollview = uiView.superview?.superview?.superview as? UIScrollView,
               !context.coordinator.isAdded {
                scrollview.delegate = context.coordinator
                context.coordinator.isAdded = true
            }
        }
        
        context.coordinator.width = width
        context.coordinator.spacing = spacing
        context.coordinator.itemCount = itemCount
        context.coordinator.repeatingCount = repeatingCount
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var width: CGFloat
        var spacing: CGFloat
        var itemCount: Int
        var repeatingCount: Int
        ///Tells us whether the delegate is added or not
        var isAdded: Bool = false
        
        init(width: CGFloat, spacing: CGFloat, itemCount: Int, repeatingCount: Int) {
            self.width = width
            self.spacing = spacing
            self.itemCount = itemCount
            self.repeatingCount = repeatingCount
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard itemCount > 0 else { return }
            let minX = scrollView.contentOffset.x
            let mainContentSize = CGFloat(itemCount) * width
            let spacingSize = CGFloat(itemCount) * spacing
            
            if minX > (mainContentSize + spacingSize) {
                scrollView.contentOffset.x -= (mainContentSize + spacingSize)
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += (mainContentSize + spacingSize)
            }
            
        }
        
        
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    LoopingScrollView(width: 200, spacing: 10, items: previewItems) { elem in
        RoundedRectangle(cornerRadius: 15)
            .fill(elem.color.gradient)
    }
    .frame(height: 200)
}
