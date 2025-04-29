//
//  PhaseAnimatorExample.swift
//  AdvancedAnimationsAPIs
//
//  Created by Matteo Buompastore on 29/04/25.
//

import SwiftUI

/// OS Infos
enum OSInfo: String, CaseIterable {
    case ios = "iOS"
    case ipad = "iPadOS"
    case visionOS = "visionOS"
    case appleWatch = "watchOS"
    case macbook = "macOS"
    
    var symbolImage: String {
        switch self {
            case .ios: "iphone"
            case .appleWatch: "applewatch"
            case .ipad: "ipad"
            case .macbook: "macbook"
            case .visionOS: "vision.pro"
        }
    }
    
}

struct PhaseAnimatorExample: View {
    
    @State private var isAnimationEnabled: Bool = false
    
    var body: some View {
        ZStack {
            if isAnimationEnabled {
                PhaseAnimator(OSInfo.allCases) { info in
                    VStack(spacing: 20) {
                        ZStack {
                            ForEach(OSInfo.allCases, id: \.rawValue) { osInfo in
                                let isSame = osInfo == info
                                if isSame {
                                    Image(systemName: osInfo.symbolImage)
                                        .font(.system(size: 100, weight: .ultraLight, design: .rounded))
                                        .transition(.blurReplace(.upUp))
                                }
                            } //: Loop OS
                        } //: ZSTACK
                        .frame(height: 120)
                        
                        VStack(spacing: 6) {
                            
                            Text("Available on")
                                .font(.callout)
                                .foregroundStyle(.gray)
                            
                            ZStack {
                                ForEach(OSInfo.allCases, id: \.rawValue) { osInfo in
                                    let isSame = osInfo == info
                                    if isSame {
                                        Text(osInfo.rawValue)
                                            .font(.largeTitle)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                            .transition(.push(from: .bottom))
                                    }
                                } //: Loop OS
                            } //: ZSTACK
                            .frame(maxWidth: .infinity)
                            .clipped()
                            
                        } //: VSTACK
                        
                    } //: VSTACK
                } animation: { _ in
                        .interpolatingSpring(.bouncy(duration: 1, extraBounce: 0)).delay(1.5)
                }
            }
        } //: ZSTACK
        .task {
            isAnimationEnabled = true
        }
    }
}

#Preview {
    NavigationStack {
        PhaseAnimatorExample()
            .navigationTitle("Phase Animator")
            .navigationBarTitleDisplayMode(.inline)
    }
}
