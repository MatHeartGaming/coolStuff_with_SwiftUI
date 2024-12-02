//
//  ContentView.swift
//  App-Wide Overlays
//
//  Created by Matteo Buompastore on 02/12/24.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    // MARK: Properties
    @State private var show: Bool = false
    @State private var showSheet: Bool = false
    @State private var text: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Message", text: $text)
                Button("Floating View Player") {
                    show.toggle()
                }
                .universalOverlay(show: $show) {
                    FloatingViewPlayerView(text: $text, show: $showSheet)
                }
                
                Button("Show Dummy Sheet") {
                    showSheet.toggle()
                }
                
            } //: LIST
            .navigationTitle("Universal Overlay")
            .sheet(isPresented: $showSheet) {
                Text("Hello from Sheet!")
            }
        } //: NAVIGATION
    }
}

struct FloatingViewPlayerView: View {
    
    @Binding var text: String
    @Binding var show: Bool
    
    /// View Properties
    @State private var player: AVPlayer?
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    
    var body: some View {
        /*Circle()
            .fill(Color.red)
            .overlay {
                Text("\(text)")
            }
            .frame(width: 50, height: 50)
            .onTapGesture {
                print("Tapped Circle!")
            }*/
        GeometryReader {
            let size = $0.size
            Group {
                if let videoURL {
                    VideoPlayer(player: player)
                        .background(.black)
                        .clipShape(.rect(cornerRadius: 25))
                } else {
                    RoundedRectangle(cornerRadius: 25)
                }
            } //: GROUP
            .frame(height: 250)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation + lastStoredOffset
                        offset = translation
                    }
                    .onEnded{ value in
                        withAnimation(.bouncy) {
                            /// Limit to screen bounds
                            offset.width = 0
                            if offset.height < 0 {
                                offset.height = 0
                            }
                            if offset.height > (size.height - 250) {
                                offset.height = (size.height - 250)
                            }
                        }
                        lastStoredOffset = offset
                    }
            )
            .frame(maxHeight: .infinity, alignment: .top)
        } //: GEOMETRY
        .padding(.horizontal, 15)
        .transition(.blurReplace)
        .onAppear {
            if let videoURL {
                player = AVPlayer(url: videoURL)
                player?.play()
            }
        }
    }
    
    var videoURL: URL? {
        if let bundle = Bundle.main.path(forResource: "video", ofType: "mp4") {
            return .init(filePath: bundle)
        }
        return nil
    }
}

extension CGSize {
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}

#Preview {
    RootView {
        ContentView()
    }
}
