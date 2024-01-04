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
    
    
    var body: some View {
        VStack {
            let videoPlayerSize = CGSize(width: size.width, height: size.height / 3.5)
            
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
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                showPlayerControls.toggle()
                            }
                            
                            /// Timing out contorls, only if the video is playing
                            timeoutControls()
                            
                        }
                        .overlay(alignment: .bottom) {
                            VideoSeekerView(videoSize: videoPlayerSize)
                        }
                }
                
            } //: ZSTACK
            .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
            
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
        .padding(.top, safeArea.top)
        .onAppear {
            /// Adding ovserver to update seeker when the video is playing
            player?.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 1), queue: .main, using: { time in
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
        }
    }
    
    
    // MARK: - VIEWS
    
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
                    /// Setting video to start and play again
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
                .frame(width: max(size.width * progress, 0))
            
        } //: ZSTACK
        .frame(height: 3)
        .overlay(alignment: .leading) {
            Circle()
                .fill(.red)
                .frame(width: 15, height: 15)
                .scaleEffect(showPlayerControls || isDragging ? 1 : 0.001, anchor: progress * size.width > 15 ? .trailing : .leading)
                /// For more dragging space
                .frame(width: 50, height: 50)
                .contentShape(.circle)
                /// Moving alongside with Gesture Progress
                .offset(x: size.width * progress)
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
                        })
                        .onEnded({ value in
                            lastDraggedProgress = progress
                            /// Bringing video playback to dragged time
                            if let currentPlayerItem = player?.currentItem {
                                let totalDuration = currentPlayerItem.duration.seconds
                                player?.seek(to: .init(seconds: totalDuration * progress, preferredTimescale: 1))
                                
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
    
}

#Preview {
    GeometryReader {
        let size = $0.size
        let safeArea = $0.safeAreaInsets
        
        Home(size: size, safeArea: safeArea)
    } //: GEOMETRY
}
