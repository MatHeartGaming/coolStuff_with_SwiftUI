//
//  Photo.swift
//  JSON Parsing Pagination
//
//  Created by Matteo Buompastore on 25/03/24.
//

import SwiftUI

struct Photo: Identifiable, Codable, Hashable {
    let id: String
    var author: String
    var url: String
    private var downloadURLString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case url
        case downloadURLString = "download_url"
    }
    
    var downloadURL: URL? {
        return URL(string: downloadURLString)
    }
    
    var imageURL: URL? {
        return URL(string: "https://picsum.photos/id/\(id)/256/256.jpg")
    }
}
