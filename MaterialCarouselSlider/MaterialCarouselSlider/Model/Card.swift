//
//  Card.swift
//  MaterialCarouselSlider
//
//  Created by Matteo Buompastore on 05/01/24.
//

import SwiftUI

struct Card: Identifiable, Hashable, Equatable {
    
    var id = UUID()
    var image: String
    var previousOffset: CGFloat = .zero
    
}
