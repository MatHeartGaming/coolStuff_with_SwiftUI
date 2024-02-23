//
//  BottomSheetHelper.swift
//  Apple Maps Bottomsheet
//
//  Created by Matteo Buompastore on 23/02/24.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    /// Default tab bar height = 49
    func bottomMaskForSheet(mask: Bool = true, _ height: CGFloat = 49) -> some View {
        self
            .background(SheetRootViewFinder(mask: mask, height: height))
    }
    
}


fileprivate struct SheetRootViewFinder: UIViewRepresentable {
    
    // MARK: - Properties
    var mask: Bool
    var height: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let rootView = uiView.viewBeforeWindow,
                let window = rootView.window {
                let safeArea = rootView.safeAreaInsets
                /// Updating height so that it will create a empty space at the bottom
                rootView.frame = .init(
                    origin: .zero,
                    size: CGSize(
                        width: window.frame.width,
                        height: window.frame.height - (mask ? (height + safeArea.bottom) : 0)
                    )
                ) //: RootView
                
                rootView.clipsToBounds = true
                for view in rootView.subviews {
                    /// Removing shadows
                    view.layer.shadowColor = UIColor.clear.cgColor
                    
                    if view.layer.animationKeys() != nil {
                        if let cornerRadiusView = view.allSubviews.first(where: {
                            $0.layer.animationKeys()?.contains("cornerRadius") ?? false}) {
                            /// This removes the ugly animation when the sheet first appears
                            cornerRadiusView.layer.maskedCorners = []
                        }
                    }
                } //: Loop subviews
            }
        }
    }
}

fileprivate extension UIView {
    
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        return superview?.viewBeforeWindow
    }
    
    /// Retrieving all subviews from a UIView
    var allSubviews: [UIView] {
        return subviews.flatMap { [$0] + $0.subviews }
    }
    
}


#Preview {
    ContentView()
}
