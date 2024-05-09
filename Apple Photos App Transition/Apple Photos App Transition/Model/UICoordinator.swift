//
//  UICoordinator.swift
//  Apple Photos App Transition
//
//  Created by Matteo Buompastore on 09/05/24.
//

import SwiftUI

@Observable
class UICoordinator {
    
    var items: [Item] = sampleImages.compactMap({
        Item(title: $0.title, image: $0.image, previewImage: $0.image)
    })
    
    /// Animation properties
    var selectedItem: Item?
    var animateView: Bool = false
    var showDetailView: Bool = false
    
    
}
