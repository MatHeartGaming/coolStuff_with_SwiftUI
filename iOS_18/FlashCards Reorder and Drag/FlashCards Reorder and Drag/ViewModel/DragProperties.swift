//
//  DragProperties.swift
//  FlashCards Reorder and Drag
//
//  Created by Matteo Buompastore on 28/01/25.
//

import SwiftUI
import CoreData

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
    
    func changeGroup(_ context: NSManagedObjectContext) {
        guard let sourceCard, let destinationCategory else { return }
        
        /// Place newly added card to the bottom of that category
        sourceCard.order = destinationCategory.nextOrer
        
        /// Change the category!
        sourceCard.category = destinationCategory
        
        try? context.save()
        resetAllProperties()
    }
    
    func swapCardsInSameGroup(_ destinationCard: FlashCard) {
        guard let sourceCard else { return }
        
        let sourceIndex = sourceCard.order
        let destinationIndex = destinationCard.order
        
        sourceCard.order = destinationIndex
        destinationCard.order = sourceIndex
        
        isCardsSwapped = true
    }
    
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


extension Category {
    var nextOrer: Int32 {
        let allCards = cards?.allObjects as? [FlashCard] ?? []
        let lastOrderValue = allCards.max(by: { $0.order < $1.order })?.order ?? 0
        return lastOrderValue + 1
    }
}
