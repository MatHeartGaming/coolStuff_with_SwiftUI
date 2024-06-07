//
//  GlitchText.swift
//  Glitch Text Effect
//
//  Created by Matteo Buompastore on 07/06/24.
//

import SwiftUI

struct GlitchFrame: Animatable {
    
    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>> {
        get {
            return .init(top, .init(center, .init(bottom, shadowOpacity)))
        }
        set {
            top = newValue.first
            center = newValue.second.first
            bottom = newValue.second.second.first
            shadowOpacity = newValue.second.second.second
        }
    }
    
    var top: CGFloat = 0
    var center: CGFloat = 0
    var bottom: CGFloat = 0
    var shadowOpacity: CGFloat = 0
}

/// Result Builder
@resultBuilder
struct GlitchFrameBuilder {
    static func buildBlock(_ components: LinearKeyframe<GlitchFrame>...) -> [LinearKeyframe<GlitchFrame>] {
        return components
    }
}

struct GlitchText: View {
    
    // MARK: - Properties
    var text: String
    
    /// Config
    var trigger: Bool
    var shadow: Color
    var radius: CGFloat
    var frames: [LinearKeyframe<GlitchFrame>]
    
    init(text: String, trigger: Bool, shadow: Color = .red, radius: CGFloat = 1, @GlitchFrameBuilder frames: @escaping ()-> [LinearKeyframe<GlitchFrame>]) {
        self.text = text
        self.trigger = trigger
        self.shadow = shadow
        self.radius = radius
        self.frames = frames()
    }
    
    var body: some View {
        KeyframeAnimator(initialValue: GlitchFrame(), trigger: trigger) { value in
            ZStack {
                TextView(.top, offset: value.top, opacity: value.shadowOpacity)
                TextView(.center, offset: value.center, opacity: value.shadowOpacity)
                TextView(.bottom, offset: value.bottom, opacity: value.shadowOpacity)
            } //: ZSTACK
            //.compositingGroup()
        } keyframes: { value in
            for frame in frames {
                frame
            }
        }

    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    func TextView(_ alignment: Alignment, offset: CGFloat, opacity: CGFloat) -> some View {
        Text(text)
            .mask {
                if alignment == .top {
                    VStack(spacing: 0) {
                        Rectangle()
                        ExtendedSpacer()
                        ExtendedSpacer()
                    } //: VSTACK
                } else if alignment == .center {
                    VStack(spacing: 0) {
                        ExtendedSpacer()
                        Rectangle()
                        ExtendedSpacer()
                    } //: VSTACK
                } else {
                    VStack(spacing: 0) {
                        ExtendedSpacer()
                        ExtendedSpacer()
                        Rectangle()
                    } //: VSTACK
                }
            }
            .shadow(color: shadow.opacity(opacity), radius: radius, x: offset, y: offset / 2)
            .offset(x: offset)
    }
    
    
    @ViewBuilder
    private func ExtendedSpacer() -> some View {
        Spacer(minLength: 0)
            .frame(maxHeight: .infinity)
    }
    
}

#Preview {
    GlitchText(text: "MatBuompy", trigger: true) {
        
    }
}
