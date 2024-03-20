//
//  HoldDownButton.swift
//  Long Press Button ProgressBar
//
//  Created by Matteo Buompastore on 20/03/24.
//

import SwiftUI

struct HoldDownButton: View {
    
    // MARK: - Properties
    var text: String
    var paddingHorizontal: CGFloat = 25
    var paddingVertical: CGFloat = 12
    var duration: CGFloat = 1
    var scale: CGFloat = 0.95
    var background: Color
    var loadingTint: Color
    var shape: AnyShape = .init(.capsule)
    var action: () -> Void
    
    /// UI
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    @State private var timerCount: CGFloat = 0
    @State private var progress: CGFloat = 0
    @State private var isHolding: Bool = false
    @State private var isCompleted: Bool = false
    
    var body: some View {
        Text(text)
            .padding(.vertical, paddingVertical)
            .padding(.horizontal, paddingHorizontal)
            .background {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(background.gradient)
                    GeometryReader {
                        let size = $0.size
                        
                        if !isCompleted {
                            Rectangle()
                                .fill(loadingTint)
                                .frame(width: size.width * progress)
                                .transition(.opacity)
                        }
                        
                    } //: GEOMETRY
                } //: ZSTACK
            }
            .clipShape(shape)
            .contentShape(shape)
            .scaleEffect(isHolding ? scale : 1)
            .animation(.snappy, value: isHolding)
            /// Gestures
            .gesture(longPressGesture.simultaneously(with: dragGesture))
            /// It does not appear although it suggests it...
            //.simulataneousGesture(dragGesture)
            .onReceive(timer) { _ in
                if isHolding && progress != 1 {
                    timerCount += 0.01
                    progress = max(min(timerCount / duration, 1), 0)
                }
            }
            /// Since we only need to start the timer when the button is pressed
            .onAppear(perform: cancelTimer)
    }
    
    
    // MARK: - Functions
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded { _ in
                print("Drag")
                guard !isCompleted else { return }
                cancelTimer()
                withAnimation(.snappy) {
                    reset()
                }
            }
    }
    
    var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: duration)
            .onChanged { status in
                /// Resetting to inital state
                isCompleted = false
                reset()
                print("On changed")
                isHolding = status
                addTimer()
            }
            .onEnded { status in
                isHolding = false
                cancelTimer()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCompleted = status
                }
                action()
            }
    }
    
    private func addTimer() {
        timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    }
    
    private func cancelTimer() {
        timer.upstream.connect().cancel()
    }
    
    private func reset() {
        isHolding = false
        progress = 0
        timerCount = 0
    }
    
}

#Preview {
    HoldDownButton(text: "Hold to Increase", background: .black, loadingTint: .gray.opacity(0.6)) {
        
    }
    .foregroundStyle(.white)
}

#Preview {
    ContentView()
}
