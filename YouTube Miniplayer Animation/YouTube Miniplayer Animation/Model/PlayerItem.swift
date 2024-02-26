//
//  PlayerItem.swift
//  YouTube Miniplayer Animation
//
//  Created by Matteo Buompastore on 26/02/24.
//

import SwiftUI

let dummyDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce massa erat, tincidunt non laoreet id, fermentum vel magna. Curabitur sapien dui, porta ac euismod ut, egestas a metus. Suspendisse ut lobortis ligula."

struct PlayerItem: Identifiable, Equatable {
    
    let id = UUID()
    var title: String
    var author: String
    var image: String
    var description: String = dummyDescription
    
}

let items: [PlayerItem] = [
    .init(title: "Apple Vision Pro", author: "Andrew", image: "thumb1"),
    .init(title: "Expense Tracker", author: "kavvino", image: "thumb2"),
    .init(title: "Animatable", author: "kavvino", image: "thumb3"),
    .init(title: "Animated", author: "kavvino", image: "thumb4"),
    .init(title: "Apple Vision Pro Unboxing", author: "Andrew", image: "thumb1"),
]
