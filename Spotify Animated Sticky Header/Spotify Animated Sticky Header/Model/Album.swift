//
//  Album.swift
//  Spotify Animated Sticky Header
//
//  Created by Matteo Buompastore on 26/01/24.
//

import SwiftUI

struct Album: Identifiable {
    let id = UUID().uuidString
    var albumName: String
    var albumImage: String
    var isLiked: Bool = false
}

var albums: [Album] = [
    .init(albumName: "A Head Full of Dreams", albumImage: "album1"),
    .init(albumName: "A Rush of Blood to the Head", albumImage: "album2"),
    .init(albumName: "Christmas Lights", albumImage: "album3"),
    .init(albumName: "Everyday Life", albumImage: "album4"),
    .init(albumName: "Ghost Stories", albumImage: "album5"),
    .init(albumName: "Live in Buenos Aires", albumImage: "album6"),
    .init(albumName: "Music of the Spheres", albumImage: "album7"),
    .init(albumName: "Mylo Xyloto", albumImage: "album8"),
    .init(albumName: "Parachutes", albumImage: "album9"),
    .init(albumName: "XY", albumImage: "album10")
]
