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
    
    /// Scroll Positions
    var detailScrollPosition: String?
    var detailIndicatorPosition: String?
    
    /// Gesture Properties
    var offset: CGSize = .zero
    var dragProgress: CGFloat = .zero
    
    func didDetailPageChanged() {
        if let updatedItem = items.first(where: { $0.id == detailScrollPosition }) {
            selectedItem = updatedItem
            /// Updating Indicator page
            detailIndicatorPosition = updatedItem.id
        }
    }
    
    func didDetailIndicatorPageChanged() {
        if let updatedItem = items.first(where: { $0.id == detailIndicatorPosition }) {
            selectedItem = updatedItem
            /// Updating detail page
            detailScrollPosition = updatedItem.id
        }
    }
    
    
    func toggleView(show: Bool) {
        if show {
            detailScrollPosition = selectedItem?.id
            detailIndicatorPosition = selectedItem?.id
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.showDetailView = true
            }
        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = false
                offset = .zero
            } completion: {
                self.resetAnimationProperties()
            }
        }
    }
    
    func resetAnimationProperties() {
        selectedItem = nil
        detailScrollPosition = nil
        offset = .zero
        dragProgress = .zero
        detailIndicatorPosition = nil
    }
    
}
