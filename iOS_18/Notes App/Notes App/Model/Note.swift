//
//  Note.swift
//  Notes App
//
//  Created by Matteo Buompastore on 30/09/24.
//

import SwiftUI

struct Note: Identifiable {
    
    let id: String = UUID().uuidString
    var color: Color
    
    /// View
    var allowsHitTesting: Bool = false
    
}

var mockNotes: [Note] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .purple),
]
