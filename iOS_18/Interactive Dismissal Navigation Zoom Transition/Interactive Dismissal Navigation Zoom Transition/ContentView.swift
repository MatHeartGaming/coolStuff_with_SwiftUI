//
//  ContentView.swift
//  Interactive Dismissal Navigation Zoom Transition
//
//  Created by Matteo Buompastore on 18/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("With Interactive Dismiss") {
                    Text("Hello from View 1")
                        .navigationTransition(.zoom(sourceID: 1, in: animation))
                }
                .matchedTransitionSource(id: 1, in: animation)
                .listRowBackground(Color.white)
                
                NavigationLink("Without Interactive Dismiss") {
                    Text("Hello from View 2")
                        .navigationTransition(.zoom(sourceID: 2, in: animation))
                        .disableZoomInteractiveDismissal()
                }
                .matchedTransitionSource(id: 2, in: animation)
                .listRowBackground(Color.white)
            }
            .navigationTitle("Zoom Transition")
        } //: NAVIGATION
    }
}

extension View {
    func disableZoomInteractiveDismissal() -> some View {
        self
            .background(RemoveZoomDismissGestures())
    }
    
    
}

fileprivate struct RemoveZoomDismissGestures: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        removeGestures(from: view)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    private func removeGestures(from view: UIView) {
        DispatchQueue.main.async {
            if let zoomViewController = view.viewController?.view {
                zoomViewController.gestureRecognizers?.removeAll {
                    ($0.name ?? "").contains("ZoomInteractive")
                }
            }
        }
    }
}

extension UIView {
    var viewController: UIViewController? {
        sequence(first: self) { $0.next }
            .compactMap({ $0 as? UIViewController })
            .first
    }
}

#Preview {
    ContentView()
}
