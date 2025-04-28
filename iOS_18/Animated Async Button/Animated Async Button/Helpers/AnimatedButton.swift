//
//  AnimatedButton.swift
//  Animated Async Button
//
//  Created by Matteo Buompastore on 28/04/25.
//

import SwiftUI

struct AnimatedButton: View {
    
    // MARK: Properties
    var config: Config
    var shape: AnyShape = .init(.capsule)
    var onTap: () async -> Void
    
    /// UI
    @State private var isLoading: Bool = false
    
    var body: some View {
        Button {
            Task {
                isLoading = true
                await onTap()
                isLoading = false
            }
        } label: {
            HStack(spacing: 10) {
                if let symbolImageName = config.symbolImage {
                    Image(systemName: symbolImageName)
                        .font(.title3)
                        .transition(.blurReplace)
                } else {
                    if isLoading {
                        Spinner(tint: config.foregroundColor, lineWidth: 4)
                            .frame(width: 20, height: 20)
                            .transition(.blurReplace)
                    }
                }
                
                Text(config.title)
                    .contentTransition(.interpolate)
                    .fontWeight(.semibold)
                
            } //: HSTACK
            .padding(.horizontal, config.hPadding)
            .padding(.vertical, config.vPadding)
            .foregroundStyle(config.foregroundColor)
            .background(config.background.gradient)
            .clipShape(shape)
            .contentShape(shape)
        } //: Button
        .disabled(isLoading)
        .buttonStyle(ScaleButtonStyle())
        .animation(config.animation, value: config)
        .animation(config.animation, value: isLoading)

    }
    
    struct Config: Equatable {
        var title: String
        var foregroundColor: Color
        var background: Color
        var symbolImage: String?
        var hPadding: CGFloat = 15
        var vPadding: CGFloat = 10
        var animation: Animation = .easeInOut(duration: 0.25)
    }
}

fileprivate struct ScaleButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .animation(.linear(duration: 0.2)) {
                $0
                    .scaleEffect(configuration.isPressed ? 0.9 : 1)
            }
            
    }
}

#Preview {
    ContentView()
}
