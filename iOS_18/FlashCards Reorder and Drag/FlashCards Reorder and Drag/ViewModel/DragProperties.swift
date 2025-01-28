//
//  DragProperties.swift
//  FlashCards Reorder and Drag
//
//  Created by Matteo Buompastore on 28/01/25.
//

import SwiftUI

/// Going to create a custom Drag & Drop effect because the standard one lacks customisation option for its preview

class DragProperties: ObservableObject {
    
    @Published var show: Bool = false
    @Published var previewImage: UIImage?
    @Published var initalViewLocation: CGPoint = .zero
    @Published var updatedViewLocation: CGPoint = .zero
    
    /// Gesture
    @Published var offset: CGSize = .zero
    @Published var location: CGPoint = .zero
    
    /// Grouping and Section ReOrdering
    @Published var sourceCard: FlashCard?
    @Published var sourceCategory: Category?
    @Published var destinationCategory: Category?
    @Published var isCardsSwapped: Bool = false
    
    /// Reset all properties
    func resetAllProperties() {
        self.show = false
        self.previewImage = nil
        self.initalViewLocation = .zero
        self.updatedViewLocation = .zero
        self.offset = .zero
        self.location = .zero
        self.sourceCard = nil
        self.sourceCategory = nil
        self.destinationCategory = nil
        self.isCardsSwapped = false
    }
    
}
