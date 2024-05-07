//
//  UICoordinator.swift
//  Pinterest Grid Animation
//
//  Created by Matteo Buompastore on 07/05/24.
//

import SwiftUI

@Observable
class UICoordinator {
    
    /// Shared View Properties between Home and Detail View
    
    var scrollView: UIScrollView = .init(frame: .zero)
    var rect: CGRect = .zero
    
    /// Animation
    var animationLayer: UIImage?
    var animateView: Bool = false
    var hideLayer: Bool = false
    /// Root View
    var hideRootView: Bool = false
    
    func createVisibleAreaSnapshot() {
        let renderer = UIGraphicsImageRenderer(size: scrollView.bounds.size)
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: -scrollView.contentOffset.x, y: -scrollView.contentOffset.y)
            scrollView.layer.render(in: ctx.cgContext)
        }
        animationLayer = image
    }
    
}

struct ScrollViewExtractor: UIViewRepresentable {
    
    var result: (UIScrollView) -> Void
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.async {
            if let scrollView = view.superview?.superview?.superview as? UIScrollView {
                result(scrollView)
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
