//
//  ImageItem.swift
//  Share Sheet Extension
//
//  Created by Matteo Buompastore on 30/01/24.
//

import SwiftUI
import SwiftData

@Model
class ImageItem {
    
    @Attribute(.externalStorage)
    var data: Data
    
    init(data: Data) {
        self.data = data
    }
    
}
