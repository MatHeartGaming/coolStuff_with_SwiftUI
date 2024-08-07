//
//  SharedModel.swift
//  ZoomTransitions
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI
import AVKit

@Observable
class SharedModel {
    var videos: [Video] = files
    
    func generateThumbnails(_ video: Binding<Video>, size: CGSize) async {
        do {
            let asset = AVURLAsset(url: video.wrappedValue.fileURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.maximumSize = size
            generator.appliesPreferredTrackTransform = true
            
            let cgImage = try await generator.image(at: .zero).image
            guard let deviceColorBase = cgImage.copy(colorSpace: CGColorSpaceCreateDeviceRGB()) else { return }
            let thumbnail = UIImage(cgImage: deviceColorBase)
            await MainActor.run {
                video.wrappedValue.thumbnail = thumbnail
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

