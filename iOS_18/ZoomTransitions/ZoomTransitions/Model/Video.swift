//
//  Video.swift
//  ZoomTransitions
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

struct Video: Identifiable, Hashable {
    
    let id: UUID = UUID()
    var fileURL: URL
    var thumbnail: UIImage?
    
}

let files: [Video] = [
    URL(filePath: Bundle.main.path(forResource: "Video1", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "Video2", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "Video3", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "Video4", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "Video5", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "Video6", ofType: "mp4") ?? ""),
].compactMap { url in
    Video(fileURL: url)
}
