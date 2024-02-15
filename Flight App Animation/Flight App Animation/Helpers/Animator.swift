//
//  Animator.swift
//  Flight App Animation
//
//  Created by Matteo Buompastore on 15/02/24.
//

import SwiftUI

class Animator: ObservableObject {
    
    @Published var startAnimation: Bool = false
    
    /// Plane position
    @Published var initalPlanePosition: CGRect = .zero
    @Published var currentPaymentStatus: PaymentStatus = .initiated
    
    /// Ring status
    @Published var ringAnimation: [Bool] = [false, false]
    
    /// Loading Status
    @Published var showLoadingView: Bool = false
    
    /// Cloud View Status
    @Published var showClouds: Bool = false
    
    /// Final View
    @Published var showFinalView: Bool = false
    
    func resetAnimation() {
        self.currentPaymentStatus = .started
        self.showClouds = false
        withAnimation(.easeInOut(duration: 0.3)) {
            self.showFinalView = false
        }
        self.ringAnimation = [false, false]
        self.showLoadingView = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
            withAnimation(.easeOut) {
                self.startAnimation = false
            }
        }
    }
    
}
