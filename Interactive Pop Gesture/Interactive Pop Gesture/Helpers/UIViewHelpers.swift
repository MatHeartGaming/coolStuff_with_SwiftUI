//
//  UIViewHelpers.swift
//  Interactive Pop Gesture
//
//  Created by Matteo Buompastore on 16/11/23.
//

import SwiftUI

struct AttachGestureView: UIViewRepresentable {
    @Binding var gesture: UIPanGestureRecognizer
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            // Look for parent controller
            if let parentViewController = uiView.parentViewController {
                if let navigationController = parentViewController.navigationController {
                    if let _ = navigationController.view.gestureRecognizers?.first(where: {
                        $0.name == gesture.name}) {
                        print("Already Attached")
                    } else {
                        navigationController.addFullSwipeGesture(gesture)
                    }
                }
            }
        }
    }
    
    
}

fileprivate extension UINavigationController {
    
    func addFullSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureSelector = interactivePopGestureRecognizer?.value(forKey: "targets") else {return}
        gesture.setValue(gestureSelector, forKey: "targets")
        view.addGestureRecognizer(gesture)
    }
    
}

fileprivate extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) {
            $0.next
        }.first(where: {$0 is UIViewController}) as? UIViewController
    }
}
