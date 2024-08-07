//
//  DetailView.swift
//  ZoomTransitions
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI
import AVKit

struct DetailView: View {
    
    // MARK: Properties
    var video: Video
    var animation: Namespace.ID
    @Environment(SharedModel.self) private var sharedModel
    
    /// UI
    @State private var hidesThumbnail: Bool = false
    @State private var scrollID: UUID?
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            Color.black
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(sharedModel.videos) { video in
                        VideoPlayerView(video: video)
                            .frame(width: size.width, height: size.height)
                    } //: Loop
                } //: Lazy VSCROLL
                .scrollTargetLayout()
            } //: Scroll
            .scrollPosition(id: $scrollID)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .zIndex(hidesThumbnail ? 1 : 0)
            
            if let thumbnail = video.thumbnail, !hidesThumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 15))
                    .task {
                        scrollID = video.id
                        try? await Task.sleep(for: .seconds(0.15))
                        hidesThumbnail = true
                    }
            }
        } //: GEOMETRY
        .ignoresSafeArea()
        .navigationTransition(.zoom(sourceID: hidesThumbnail ? scrollID ?? video.id : video.id, in: animation))
    }
}

struct VideoPlayerView: View {
    
    var video: Video
    @State private var player: AVPlayer?
    
    var body: some View {
        CustomVideoPlayerView(player: $player)
            .onAppear {
                guard player == nil else { return }
                player = AVPlayer(url: video.fileURL)
            }
            .onDisappear {
                player?.pause()
            }
            .onScrollVisibilityChange { isVisible in
                if isVisible {
                    player?.play()
                } else {
                    player?.pause()
                }
            }
            .onGeometryChange(for: Bool.self) { proxy in
                let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
                let height = proxy.size.height * 0.97
                
                return -minY > height || minY > height
            } action: { newValue in
                if newValue {
                    player?.seek(to: .zero)
                    player?.pause()
                }
            }

    }
    
}

#Preview {
    ContentView()
        .environment(SharedModel())
}
