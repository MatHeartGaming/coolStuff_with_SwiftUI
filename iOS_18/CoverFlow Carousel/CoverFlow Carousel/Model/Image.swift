//
//  Image.swift
//  CoverFlow Carousel
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

struct ImageModel: Identifiable {
    let id = UUID()
    var image: String
}

var images: [ImageModel] = (1...8).compactMap({ ImageModel(image: "Profile \($0)") })
