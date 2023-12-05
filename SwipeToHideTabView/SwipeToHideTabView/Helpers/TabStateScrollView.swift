//
//  TabStateScrollView.swift
//  SwipeToHideTabView
//
//  Created by Matteo Buompastore on 05/12/23.
//

import SwiftUI

struct TabStateScrollView<Content: View>: View {
    
    var axis: Axis.Set
    var showsIndicators: Bool
    @Binding var tabState: Visibility
    var content: Content
    
    init(axis: Axis.Set, showsIndicators: Bool, tabState: Binding<Visibility>, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self._tabState = tabState
        self.content = content()
    }
    
    @State private var offsetV: CGFloat = 0
    
    var body: some View {
        if #available(iOS 17, *) {
            ScrollView(axis) {
                content
            }
            .scrollIndicators(showsIndicators ? .visible : .hidden)
            .background {
                CustomGesture { gesture in
                    handleTabState(gesture)
                }
            }
        } else {
            ScrollView(axis, showsIndicators: showsIndicators) {
                content
            }
            .background(
                CustomGesture { gesture in
                    handleTabState(gesture)
                }
            )
        }
    }
    
    /// Handling tab state
    func handleTabState(_ gesture: UIPanGestureRecognizer) {
        let offsetV = gesture.translation(in: gesture.view).y
        let velocityY = gesture.velocity(in: gesture.view).y
        
        if velocityY < 0 {
            /// Swiping up
            if -(velocityY / 5) > 60 && tabState == .visible {
                tabState = .hidden
            }
        } else {
            /// Swiping down
            if (velocityY / 5) > 40 && tabState == .hidden {
                tabState = .visible
            }
        }
    }
    
}

/// Adding simulaneus UIPan Gesture to know about what direction the user is swiping
fileprivate struct CustomGesture: UIViewRepresentable {
    
    var onChange: (UIPanGestureRecognizer) -> Void
    
    /// Gesture ID
    private let gestureID = UUID().uuidString
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onChange: onChange)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let superView = uiView.superview?.superview, 
                !(superView.gestureRecognizers?.contains(where: { $0.name == gestureID }) ?? false) {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                gesture.name = gestureID
                gesture.delegate = context.coordinator
                superView.addGestureRecognizer(gesture)
            }
        }
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        
        var onChange: (UIPanGestureRecognizer) -> ()
        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }
        
        @objc
        func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
    }
    
}

#Preview {
    ContentView()
}
