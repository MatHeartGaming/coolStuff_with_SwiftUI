//
//  Item.swift
//  Grid MultiSelection Pan Gesture
//
//  Created by Matteo Buompastore on 21/01/25.
//

import SwiftUI

struct Item: Identifiable {

    let id: String = UUID().uuidString
    var color: Color
    
    var location: CGRect = .zero
    
}
