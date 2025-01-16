//
//  ImageModel.swift
//  Carousel With Ambient Background Effect
//
//  Created by Matteo Buompastore on 16/01/25.
//

import SwiftUI

struct ImageModel: Identifiable {
    
    let id: String = UUID().uuidString
    var altText: String
    var image: String
    
}

let images: [ImageModel] = [
    .init(altText: "Image 1", image: "pic"),
    .init(altText: "Image 2", image: "pic2"),
    .init(altText: "Image 3", image: "pic3"),
    .init(altText: "Image 4", image: "pic4"),
]
