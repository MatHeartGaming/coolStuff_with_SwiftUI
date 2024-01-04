//
//  Home.swift
//  YouTube Video Player
//
//  Created by Matteo Buompastore on 04/01/24.
//

import SwiftUI
import AVKit

struct Home: View {
    
    // MARK: - PROPERTIES
    var size: CGSize
    var safeArea: EdgeInsets
    
    /// VIew Properties
    @State private var player: AVPlayer? = {
        if let bundle = Bundle.main.path(forResource: "video1", ofType: "mov") {
            return .init(url: URL(fileURLWithPath: bundle))
            // return .init(url: URL(filePath: bundle)) // <-- MARK: On iOS 16 or above
        }
        return nil
    }()
    @State private var showPlayerControls = false
    @State private var isPlaying = false
    @State private var timeoutTask: DispatchWorkItem?
    @State private var isFinishedPlaying = false
    
    /// Video Seeker properties
    @GestureState private var isDragging: Bool = false
    @State private var isSeeking = false
    @State private var progress: CGFloat = 0
    @State private var lastDraggedProgress: CGFloat = 0
    @State private var isObserverAdded: Bool = false
    
    /// Video seekr thumnails
    @State private var thumbnailFrames = [UIImage]()
    @State private var draggingImage: UIImage?
    @State private var playerStatusObserver: NSKeyValueObservation?
    /// Rotation Properties
    @State private var isRotated = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            /// Swapping Size when rotated
            let playerWidth = !isRotated ? size.width : size.height
            let playerHeight = !isRotated ? (size.height / 3.5) : size.width
            let videoPlayerSize = CGSize(width: playerWidth, height: playerHeight)
            
            /// Custom Video Player
            ZStack {
                if let player {
                    CustomVideoPlayer(player: player)
                        .overlay {
                            Rectangle()
                                .fill(.black.opacity(0.4))
                                .opacity(showPlayerControls || isDragging ? 1 : 0)
                                /// Animating Drag State
                                .animation(.easeInOut(duration: 0.35), value: isDragging)
                                .overlay {
                                    PlaybackControls()
                                }
                        } //: Overlay Controls
                        .overlay {
                            HStack(spacing: 60) {
                                DoubleTapSeek {
                                    /// Seeking back 10 sec
                                    seekVideo(forward: false)
                                }
                                
                                DoubleTapSeek(isForward: true) {
                                    /// Seeking forward 10 secs
                                    seekVideo()
                                }
                            } //: HSTACK
                        } //: Overlay Double tap back/forward
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                showPlayerControls.toggle()
                            }
                            
                            /// Timing out contorls, only if the video is playing
                            timeoutControls()
                            
                        }
                        .overlay(alignment: .leading) {
                            SeekerThumnailView(videoPlayerSize)
                                .offset(y: isRotated ? 80 : 0)
                        } //: Overlay Thumnails
                        .overlay(alignment: .bottom) {
                            VideoSeekerView(videoSize: videoPlayerSize)
                                .offset(y: isRotated ? -15 : 0)
                        } //: Overlay SeekerView
                }
                
            } //: ZSTACK
            .background {
                Rectangle()
                    .fill(.black)
                    /// Since view is rotated the trailing side is the bottom
                    .padding(.trailing, isRotated ? -safeArea.bottom : 0)
            }
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        if -value.translation.height > 100 {
                            /// Rotate player
                            withAnimation(.smooth) {
                                isRotated = true
                            }
                        } else {
                            /// Go back to normal
                            withAnimation(.smooth) {
                                isRotated = false
                            }
                        }
                    })
            )
            .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
            /// To avoid other views expansion set its native view height
            .frame(width: size.width, height: size.height / 3.5, alignment: .bottomLeading)
            .offset(y: isRotated ? -((size.width / 2) + safeArea.bottom) : 0)
            .rotationEffect(.degrees(isRotated ? 90 : 0), anchor: .topLeading)
            /// Making it top view
            .zIndex(1000)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { index in
                        GeometryReader {
                            let size = $0.size
                            
                            Image("thumb\(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .clipShape(.rect(cornerRadius: 15, style: .continuous))
                        } //: GEOMETRY
                        .frame(height: 220)
                    } //: LOOP
                } //: VSTACK
                .padding(EdgeInsets(top: 20,
                                    leading: 15,
                                    bottom: 15 + safeArea.bottom,
                                    trailing: 15)
                )
            } //: SCROLL
            
        } //: VSTACK
        //.padding(.top, safeArea.top)
        .onAppear {
            guard !isObserverAdded else { return }
            /// Adding ovserver to update seeker when the video is playing
            player?.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 600), queue: .main, using: { time in
                /// Calculating video progress
                if let currentPlayerItem = player?.currentItem {
                    let totalDuration = currentPlayerItem.duration.seconds
                    guard let currentDuration = player?.currentTime().seconds else {
                        return
                    }
                    
                    let calculatedProgress = currentDuration / totalDuration
                    if !isSeeking {
                        progress = calculatedProgress
                        lastDraggedProgress = progress
                    }
                    
                    if calculatedProgress == 1 {
                        /// Video has finiehed playing
                        isFinishedPlaying = true
                        isPlaying = false
                    }
                }
            })
            
            isObserverAdded = true
            
            /// Before generating thumbails, check if the video is loaded
            if #available(iOS 16, *) {
                playerStatusObserver = player?.observe(\.status, options: .new, changeHandler: { player, _ in
                    if player.status == .readyToPlay && thumbnailFrames.isEmpty {
                        generateThumbnailFrames()
                    }
                })
            }
        }
        .onDisappear {
            /// Clear observers
            playerStatusObserver?.invalidate()
        }
    }
    
    
    // MARK: - VIEWS
    
    @ViewBuilder
    func SeekerThumnailView(_ videoSize: CGSize) -> some View {
        let thumbSize = CGSize(width: 175, height: 120)
        ZStack {
            if let draggingImage {
                Image(uiImage: draggingImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: thumbSize.width, height: thumbSize.height)
                    .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    .overlay(alignment: .bottom) {
                        if let currentItem = player?.currentItem {
                            Text(CMTime(seconds: progress * currentItem.duration.seconds, preferredTimescale: 600).toTimeString())
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .offset(y: 25)
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.white, lineWidth: 2)
                    }
            } else {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.black)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.white, lineWidth: 2)
                    }
                
            }
        } //: ZSTACK
        .frame(width: thumbSize.width, height: thumbSize.height)
        .opacity(isDragging ? 1 : 0)
        /// Moving alongside the seeker
        .offset(x: progress * (videoSize.width - (thumbSize.width + 20)))
        .offset(x: 10)
    }
    
    @ViewBuilder
    func PlaybackControls() -> some View {
        HStack(spacing: 25) {
            
            Button(action: {}, label: {
                Image(systemName: "backward.end.fill")
                    .modifier(VideoPlayerIconStyle())
            })
            /// Disabling button since we have no action for it
            .disabled(true)
            .opacity(0.6)
            
            Button(action: {
                if isFinishedPlaying {
                    /// Resetting video to start and play again
                    resetPlayer()
                }
                /// Changing video status
                togglePlay()
                
                timeoutControls()
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPlaying.toggle()
                }
                
            }, label: {
                Image(systemName: isFinishedPlaying ? "arrow.clockwise" : (isPlaying ? "pause.fill" : "play.fill"))
                    .modifier(VideoPlayerIconStyle())
            })
            .scaleEffect(1.1)
            
            Button(action: {}, label: {
                Image(systemName: "forward.end.fill")
                    .modifier(VideoPlayerIconStyle())
            })
            /// Disabling button since we have no action for it
            .disabled(true)
            .opacity(0.6)
            
        } //: HSTACK
        .opacity(showPlayerControls && !isDragging ? 1 : 0)
        .animation(.easeIn(duration: 0.2), value: showPlayerControls)
    }
    
    /// Video Seeker view
    @ViewBuilder
    func VideoSeekerView(videoSize: CGSize) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.gray)
            
            Rectangle()
                .fill(.red)
                .frame(width: max(videoSize.width * progress, 0))
            
        } //: ZSTACK
        .frame(height: 3)
        .overlay(alignment: .leading) {
            Circle()
                .fill(.red)
                .frame(width: 15, height: 15)
                .scaleEffect(showPlayerControls || isDragging ? 1 : 0.001, anchor: progress * videoSize.width > 15 ? .trailing : .leading)
                /// For more dragging space
                .frame(width: 50, height: 50)
                .contentShape(.circle)
                /// Moving alongside with Gesture Progress
                .offset(x: videoSize.width * progress)
                .gesture(
                    DragGesture()
                        .updating($isDragging, body: { value, out, _ in
                            out = true
                        })
                        .onChanged({ value in
                            /// Cancelling existing timeout task
                            if let timeoutTask {
                                timeoutTask.cancel()
                            }
                            
                            /// Calculating progress
                            let translationX: CGFloat = value.translation.width
                            let calculatedProgress = (translationX / videoSize.width) + lastDraggedProgress
                            
                            progress = max(min(calculatedProgress, 1), 0)
                            isSeeking = true
                            
                            let draggingIndex = Int(progress / 0.01)
                            if thumbnailFrames.indices.contains(draggingIndex) {
                                draggingImage = thumbnailFrames[draggingIndex]
                            }
                        })
                        .onEnded({ value in
                            lastDraggedProgress = progress
                            /// Bringing video playback to dragged time
                            if let currentPlayerItem = player?.currentItem {
                                let totalDuration = currentPlayerItem.duration.seconds
                                player?.seek(to: .init(seconds: totalDuration * progress, preferredTimescale: 600))
                                
                                /// Reschduling timeout task
                                if isPlaying {
                                    timeoutControls()
                                }
                                
                                /// Releasing with slight delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isSeeking = false
                                }
                            }
                        })
                )
                .offset(x: progress * videoSize.width > 15 ? -15 : 0)
                .frame(width: 15, height: 15)
        }
    }
    
    
    // MARK: - FUNCTIONS
    
    /// Timing out play back controls
    private func timeoutControls() {
        /// Cancelling already pending timeout tasks
        if let timeoutTask {
            timeoutTask.cancel()
        }
        
        timeoutTask = .init(block: {
            withAnimation(.easeInOut(duration: 0.35)) {
                showPlayerControls = false
            }
        })
        
        /// Scheduling task
        if let timeoutTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: timeoutTask)
        }
    }
    
    private func resetPlayer() {
        isFinishedPlaying = false
        player?.seek(to: .zero)
        progress = .zero
        lastDraggedProgress = .zero
    }
    
    private func togglePlay() {
        if isPlaying {
            /// Pause Video
            player?.pause()
        } else {
            /// Play video
            player?.play()
        }
    }
    
    private func seekVideo(forward: Bool = true) {
        guard let player else { return }
        let seconds = player.currentTime().seconds + (forward ? +defaultStandardSeconds : -defaultStandardSeconds)
        player.seek(to: .init(seconds: seconds, preferredTimescale: 600))
    }
    
    @available(iOS 16, *)
    private func generateThumbnailFrames() {
        Task.detached {
            guard let asset = player?.currentItem?.asset else { return }
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            /// Min Size
            generator.maximumSize = .init(width: 250, height: 250)
            
            do {
                let totalDuration = try await asset.load(.duration).seconds
                var frameTimes = [CMTime]()
                /// Frame Timings
                for progress in stride(from: 0, to: 1, by: 0.01) {
                    let time = CMTime(seconds: progress * totalDuration, preferredTimescale: 600)
                    frameTimes.append(time)
                }
                
                /// Generating Frame Images
                for await result in generator.images(for: frameTimes) {
                    let cgImage = try result.image
                    await MainActor.run {
                        thumbnailFrames.append(UIImage(cgImage: cgImage))
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
}

#Preview {
    GeometryReader {
        let size = $0.size
        let safeArea = $0.safeAreaInsets
        
        Home(size: size, safeArea: safeArea)
    } //: GEOMETRY
}
