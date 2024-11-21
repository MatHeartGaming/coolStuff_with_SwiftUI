//
//  ContentView.swift
//  Fix iOS18 Gesture issues with ScrollViews
//
//  Created by Matteo Buompastore on 21/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isScrollDisabled: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Volume")
                        .font(.caption)
                    Text(isScrollDisabled ? "Scroll Disabled" : "Scroll Enabled")
                    
                    VolumeSlider(isScrollDisabled: $isScrollDisabled)
                } //: VSTACK
            } //: V-SCROLL
            .navigationTitle("Gesture - iOS 18")
            /// 2. Use the .scrollDisabled modifier
            .scrollDisabled(isScrollDisabled)
            .padding()
        }
    }
}

struct VolumeSlider: View {
    
    @Binding var isScrollDisabled: Bool
    @State private var progress: CGFloat = 0
    @State private var lastProgress: CGFloat = 0
    @State private var velocity: CGSize = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                Rectangle()
                    .fill(.black)
                    .frame(width: progress * size.width)
                
            } //: ZSTACK
            .clipShape(.rect(cornerRadius: 10))
            .simultaneousGesture(
                /// 1° method: Increase the minimum distance to make the Vertical Scroll work
                customGesture
                    .onChanged { value in
                        if #available(iOS 18, *) {
                            if (velocity == .zero) {
                                velocity = value.velocity
                            }
                            guard velocity.height == 0 else { return }
                            isScrollDisabled = true
                        }
                        let progress = (value.translation.width / size.width) + lastProgress
                        self.progress = max(min(progress, 1), 0)
                    }.onEnded { _ in
                        lastProgress = progress
                        if #available(iOS 18, *) {
                            velocity = .zero
                            isScrollDisabled = false
                        }
                    }
            )
        } //: GEOMETRY
        .frame(height: 40)
    }
    
    var customGesture: DragGesture {
        if #available(iOS 18, *) {
            DragGesture(minimumDistance: 1)
        } else {
            DragGesture()
        }
    }
    
}

#Preview {
    ContentView()
}
