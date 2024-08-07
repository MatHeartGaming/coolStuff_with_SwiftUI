//
//  CustomVideoPlayerView.swift
//  ZoomTransitions
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI
import AVKit

struct CustomVideoPlayerView: UIViewControllerRepresentable {
    
    @Binding var player: AVPlayer?
    
    func makeUIViewController(context: Context) -> some AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.player = player
    }
    
}
