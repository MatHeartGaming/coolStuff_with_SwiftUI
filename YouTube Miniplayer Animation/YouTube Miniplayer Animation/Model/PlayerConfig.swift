//
//  PlayerConfig.swift
//  YouTube Miniplayer Animation
//
//  Created by Matteo Buompastore on 26/02/24.
//

import SwiftUI

struct PlayerConfig: Equatable {
    
    var position: CGFloat = .zero
    var lastPosition: CGFloat = .zero
    var progress: CGFloat = .zero
    var selectedPlayerItem: PlayerItem?
    var showMiniPlayer: Bool = false
    
    mutating func resetPostion() {
        position = .zero
        lastPosition = .zero
        progress = .zero
    }
    
}
