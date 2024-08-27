//
//  Item.swift
//  Expandable Search Bar
//
//  Created by Matteo Buompastore on 27/08/24.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var title: String
    var image: UIImage?
}

var sampleItems: [Item] = [
    .init(title: "Leon", image: UIImage(named: "Profile 1")),
    .init(title: "Jill", image: UIImage(named: "Profile 2")),
    .init(title: "Ada", image: UIImage(named: "Profile 3")),
    .init(title: "Kratos", image: UIImage(named: "Profile 4")),
    .init(title: "Spyro", image: UIImage(named: "Profile 5")),
    .init(title: "Fortesque", image: UIImage(named: "Profile 6")),
    .init(title: "Crash Bandicoot", image: UIImage(named: "Profile 7")),
    .init(title: "lara", image: UIImage(named: "Profile 8")),
]
