//
//  Item.swift
//  Stacked Scroll View
//
//  Created by Matteo Buompastore on 20/05/24.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    var logo: String
    var title: String
    var description: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
}

var items: [Item] = [
    .init(logo: "", title: ""),
    .init(logo: "Pic 1", title: "Amazon"),
    .init(logo: "Pic 2", title: "Youtube"),
    .init(logo: "Pic 3", title: "Apple"),
    .init(logo: "Pic 7", title: "Patreon"),
    .init(logo: "Pic 5", title: "Instagram"),
    .init(logo: "Pic 6", title: "Netflix"),
    .init(logo: "Pic 7", title: "Photoshop"),
    .init(logo: "Pic 8", title: "Figma"),
]
