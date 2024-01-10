//
//  Navigation+Extension.swift
//  Hide Navbar on swipe
//
//  Created by Matteo Buompastore on 10/01/24.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func hideNavigationBarOnSwipe(_ isHidden: Bool) -> some View {
        self
            .modifier(NavBarModifier(isHidden: isHidden))
    }
    
}

private struct NavBarModifier: ViewModifier {
    
    var isHidden: Bool
    @State private var isNavBarHidden: Bool?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isHidden, { oldValue, newValue in
                isNavBarHidden = newValue
            })
            .onDisappear {
                isNavBarHidden = nil
            }
            .background(NavigationControllerExtractor(isHidden: isNavBarHidden))
    }
    
}


/// Extracting UINavigationController from SwiftUI View
private struct NavigationControllerExtractor: UIViewRepresentable {
    
    var isHidden: Bool?
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let parentController = uiView.parentController {
                if let isHidden {
                    parentController.navigationController?.hidesBarsOnSwipe = isHidden
                }
            }
        }
    }
    
}

private extension UIView {
    
    var parentController: UIViewController? {
        sequence(first: self) { view in
            view.next
        }
        .first { responder in
            return responder is UIViewController
        } as? UIViewController
    }
    
}

#Preview {
    ContentView()
}
