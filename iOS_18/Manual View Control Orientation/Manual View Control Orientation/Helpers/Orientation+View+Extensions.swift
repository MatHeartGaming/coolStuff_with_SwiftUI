//
//  Orientation+View+Extensiona.swift
//  Manual View Control Orientation
//
//  Created by Matteo Buompastore on 25/01/25.
//

import SwiftUI


extension View {
    
    /// Easy to use function to update screen orientation anywhere in the View Scope
    func modifyOrientation(_ mask: UIInterfaceOrientationMask) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            /// Constraint / Lock the orientation by setting it to the AppDelegate
            AppDelegate.orientation = mask
            
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: mask))
            /// Updating Root View Controller
            windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
    
}
