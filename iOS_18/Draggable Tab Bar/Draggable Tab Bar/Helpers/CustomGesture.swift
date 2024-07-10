//
//  CustomGesture.swift
//  Draggable Tab Bar
//
//  Created by Matteo Buompastore on 09/07/24.
//

import SwiftUI

struct CustomGesture: UIGestureRecognizerRepresentable {
    
    @Binding var isEnabled: Bool
    /// Only receives start and end updates
    var trigger: (Bool) -> Void
    var onChanged: (CGSize, CGPoint) -> Void
    
    // MARK: Be careful not to keep the 'some' keyword before the actual type. That won't make it work!!
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        recognizer.isEnabled = isEnabled
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        let view = recognizer.view
        let location = recognizer.location(in: view)
        let translation = recognizer.translation(in: view)
        
        let offset = CGSize(width: translation.x, height: translation.y)
        
        if recognizer.state == .began {
            trigger(true)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            trigger(false)
        } else {
            onChanged(offset, location)
        }
    }
    
}

