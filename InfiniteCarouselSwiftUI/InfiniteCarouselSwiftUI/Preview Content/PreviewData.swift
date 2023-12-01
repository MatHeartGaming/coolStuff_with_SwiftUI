//
//  PreviewData.swift
//  InfiniteCarouselSwiftUI
//
//  Created by Matteo Buompastore on 30/11/23.
//

import SwiftUI

var previewItems: [Item] = [.red, .blue, .green, .yellow, .black].compactMap { color in
        .init(color: color)
}
