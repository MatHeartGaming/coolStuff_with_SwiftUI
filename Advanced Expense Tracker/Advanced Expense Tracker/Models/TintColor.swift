//
//  TintColor.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI

/// Custom Tint colors for transaction rows

struct TintColor: Identifiable {
    
    let id = UUID()
    var color: String
    var value: Color
    
}

var tints: [TintColor] = [
    .init(color: "Red", value: .red),
    .init(color: "Blue", value: .blue),
    .init(color: "Pink", value: .pink),
    .init(color: "Purple", value: .purple),
    .init(color: "Brown", value: . brown),
    .init(color: "Orange", value: .orange),
]
