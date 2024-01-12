//
//  Post.swift
//  Complex Hero Animation with Synch ScrollViews
//
//  Created by Matteo Buompastore on 12/01/24.
//

import Foundation

struct Post: Identifiable {
    
    let id = UUID()
    var username: String
    var content: String
    var pics: [PicItem]
    
    /// View Based properties
    var scrollPosition: UUID?
    
}


/// Sample posts
var samplePosts: [Post] = [
    .init(username: "Geralt of Rivia", content: "Nature", pics: pics),
    .init(username: "Leon S. kenned", content: "Dead Nature", pics: pics1.reversed()),
]

private var pics: [PicItem] = (1...5).compactMap { index -> PicItem? in
    return PicItem(image: "Pic \(index)")
}



private var pics1: [PicItem] = (1...5).compactMap { index -> PicItem? in
    return PicItem(image: "Pic \(index)")
}
