//
//  CustomButton.swift
//  KeyframeAnimationTutorial
//
//  Created by Matteo Buompastore on 22/12/23.
//

import SwiftUI

struct CustomButton<ButtonContent: View>: View {
    
    var buttonTint: Color = .white
    
    // MARK: - PROPERTIES
    var content: () -> ButtonContent
    var action: () async -> TaskStatus
    
    // MARK: - UI
    @State private var isLoading: Bool = false
    @State private var taskStatus: TaskStatus = .idle
    @State private var isFailed: Bool = false
    @State private var wiggle = false
    
    /// Popup properties
    @State private var showPopup: Bool = false
    @State private var popupMessage: String = ""
    
     
    var body: some View {
        Button(action: {
            Task {
                isLoading = true
                let taskStatus = await action()
                switch taskStatus {
                    
                case .idle:
                    isFailed = false
                case .failed(let errorMessage):
                    wiggle.toggle()
                    isFailed = true
                    popupMessage = errorMessage
                    
                case .success:
                    isFailed = false
                }
                
                self.taskStatus = taskStatus
                try? await Task.sleep(for: .seconds(0.8))
                showPopup = isFailed
                self.taskStatus = .idle
                isLoading = false
            }
        }, label: {
            content()
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .opacity(isLoading ? 0 : 1)
                .lineLimit(1)
                .background {
                    GeometryReader {
                        let size = $0.size
                        let circleRadius = 50.0
                        
                        Capsule()
                            .fill(Color(taskStatus == .idle ? buttonTint : taskStatus == .success ? .green : .red).shadow(.drop(color: .black.opacity(0.15), radius: 6)))
                            .frame(width: isLoading ? circleRadius : nil, height: isLoading ? circleRadius : nil)
                            .frame(width: size.width, height: size.height, alignment: .center)
                            .overlay {
                                if isLoading && taskStatus == .idle {
                                    ProgressView()
                                }
                            }
                            .overlay {
                                if taskStatus != .idle {
                                    Image(systemName: isFailed ? "exclamationmark" : "checkmark")
                                }
                            }
                    }
                }
                .wiggle(self.wiggle)
        })
        .disabled(isLoading)
        .popover(isPresented: $showPopup, content: {
            Text(popupMessage)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .presentationCompactAdaptation(.popover)
        })
        .animation(.snappy, value: isLoading)
        .animation(.snappy, value: taskStatus)
    }
}

enum TaskStatus: Equatable {
    
    case idle
    case failed(String)
    case success
    
}

/// Custom Opacity Less Button Style
extension ButtonStyle where Self == OpacityLessButtonStyle {
    static var opacityLess: Self {
        Self()
    }
}

struct OpacityLessButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
    
}

/// Wiggle Extension
extension View {
    
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
                view
                    .offset(x: value)
            } keyframes: { value in
                KeyframeTrack {
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                }
            }

    }
    
}

#Preview {
    CustomButton {
        Text("Login")
    } action: {
        let seconds = Int.random(in: 0...3)
        try? await Task.sleep(for: .seconds(seconds))
        print("Login seconds: \(seconds)")
        return .failed("Incorrect password!")
    }

}
