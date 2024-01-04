//
//  CustomVideoPlayer.swift
//  YouTube Video Player
//
//  Created by Matteo Buompastore on 04/01/24.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewControllerRepresentable {
    
    // MARK: - PROPERTIES
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
}

#Preview {
    CustomVideoPlayer(player: AVPlayer())
}
