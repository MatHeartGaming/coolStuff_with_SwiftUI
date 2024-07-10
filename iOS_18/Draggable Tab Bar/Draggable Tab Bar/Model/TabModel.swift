//
//  TabModel.swift
//  Draggable Tab Bar
//
//  Created by Matteo Buompastore on 09/07/24.
//

import SwiftUI

struct TabModel: Identifiable {
    var id: Int
    var sybmolImage: String
    var rect: CGRect = .zero
}

let defaultOrderTabs: [TabModel] = [
    .init(id: 0, sybmolImage: "house.fill"),
    .init(id: 1, sybmolImage: "magnifyingglass"),
    .init(id: 2, sybmolImage: "bell.fill"),
    .init(id: 3, sybmolImage: "person.2.fill"),
    .init(id: 4, sybmolImage: "gearshape.fill"),
]
