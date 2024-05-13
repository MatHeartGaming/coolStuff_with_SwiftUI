//
//  Item.swift
//  Pinterest Grid Animation
//
//  Created by Matteo Buompastore on 09/05/24.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    
    let id: String = UUID().uuidString
    var title: String
    var image: UIImage?
    var previewImage: UIImage?
    var appeared: Bool = false
    
}

var sampleImages: [Item] = [
    .init(title: "Lory", image: .pic1),
    .init(title: "Ricky", image: .pic2),
    .init(title: "Matty", image: .pic3),
    .init(title: "Sery", image: .pic5),
    .init(title: "Leon", image: .pic6),
    .init(title: "She", image: .pic7),
    .init(title: "Jill", image: .pic8),
    .init(title: "Alan", image: .pic9),
    .init(title: "Ratchet", image: .pic10),
    .init(title: "Lory", image: .pic1),
    .init(title: "Ricky", image: .pic2),
    .init(title: "Matty", image: .pic3),
    .init(title: "Sery", image: .pic5),
    .init(title: "Leon", image: .pic6),
    .init(title: "She", image: .pic7),
    .init(title: "Jill", image: .pic8),
    .init(title: "Alan", image: .pic9),
    .init(title: "Ratchet", image: .pic10),
    .init(title: "Lory", image: .pic1),
    .init(title: "Ricky", image: .pic2),
    .init(title: "Matty", image: .pic3),
    .init(title: "Sery", image: .pic5),
    .init(title: "Leon", image: .pic6),
    .init(title: "She", image: .pic7),
    .init(title: "Jill", image: .pic8),
    .init(title: "Alan", image: .pic9),
    .init(title: "Ratchet", image: .pic10),
]
