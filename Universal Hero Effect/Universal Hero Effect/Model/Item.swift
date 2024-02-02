//
//  Item.swift
//  Universal Hero Effect
//
//  Created by Matteo Buompastore on 02/02/24.
//

import SwiftUI

struct Item: Identifiable {
    var id: UUID = . init()
    var title: String
    var color: Color
    var symbol: String
}

var items: [Item] = [
    .init(title: "Book Icon", color: .red, symbol: "book.fill"),
    .init(title: "Stack Icon", color: .blue, symbol: "square.stack.3d.up"),
    .init(title: "Rectangle Icon", color: .orange, symbol: "rectangle.portrait")
]
