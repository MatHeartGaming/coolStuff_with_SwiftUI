//
//  Album.swift
//  Spotify Sticky Header
//
//  Created by Matteo Buompastore on 24/01/24.
//

import SwiftUI

struct Song: Identifiable {
    
    let id = UUID()
    var songName: String
    
}

var songs: [Song] = [
    .init(songName: "Mylo Xyloto"),
    .init(songName: "Hurts Like Heaven"),
    .init(songName: "Paradise"),
    .init(songName: "Charlie Brown"),
    .init(songName: "Us Against the World"),
    .init(songName: "M.M.I.X."),
    .init(songName: "Every Teardrop is a Waterfall"),
    .init(songName: "Major Minus"),
    .init(songName: "U.F.O."),
    .init(songName: "Princess of China"),
    .init(songName: "Up in Flames"),
    .init(songName: "A Hopeful Transmission"),
    .init(songName: "Don't Let It Break Your Heart"),
    .init(songName: "Up With the Birds")
]
