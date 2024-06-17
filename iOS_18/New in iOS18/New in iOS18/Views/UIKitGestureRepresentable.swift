//
//  UIKitGestureRepresentable.swift
//  New in iOS18
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

/// We can now convert UIKit Gestures to SwiftUI's using the Gesture Representable
struct UIKitGestureRepresentable: View {
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        VStack {
            Text("Translation Y: \(offsetY)")
                .font(.title2.bold())
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(1...50, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.red.gradient)
                            .frame(height: 45)
                    } //: Loop
                } //: VSTACK
                .padding(15)
            } //: SCROLL
            .gesture(SimultaneousGesture(offset: $offsetY))
        }
    }
}

struct SimultaneousGesture: UIGestureRecognizerRepresentable {
    
    @Binding var offset: CGFloat
    
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        return Coordinator()
    }
    
    func makeUIGestureRecognizer(context: Context) -> some UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        gesture.delegate = context.coordinator
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        
    }
    
    /// Gesture responses can be handled here
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        let translation = recognizer.translation(in: recognizer.view)
        offset = translation.y
        print(offset)
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}

#Preview {
    UIKitGestureRepresentable()
}
