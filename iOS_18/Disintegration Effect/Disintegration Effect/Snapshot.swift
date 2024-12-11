//
//  Snapshot.swift
//  SwiftUIView Snapshots
//
//  Created by Matteo Buompastore on 28/11/24.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func snapshot(trigger: Bool, onComplete: @escaping (UIImage) -> Void) -> some View {
        self
            .modifier(SnapshotModiifier(trigger: trigger, onComplete: onComplete))
    }
}

fileprivate struct SnapshotModiifier: ViewModifier {
    
    var trigger: Bool
    var onComplete: (UIImage) -> Void
    
    /// Local View Modifier Properties
    @State private var view: UIView = .init(frame: .zero)
    
    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content
                .background(ViewExtractor(view: view))
                .compositingGroup()
                .onChange(of: trigger) { oldValue, newValue in
                    generateSnapshot()
                }
        } else {
            content
                .background(ViewExtractor(view: view))
                .compositingGroup()
                .onChange(of: trigger) { newValue in
                    generateSnapshot()
                }
        }
    }
    
    private func generateSnapshot() {
        if let superview = view.superview?.superview {
            let renderer = UIGraphicsImageRenderer(size: superview.bounds.size)
            let image = renderer.image { _ in
                superview.drawHierarchy(in: superview.bounds, afterScreenUpdates: true)
            }
            onComplete(image)
        }
    }
    
}

fileprivate struct ViewExtractor: UIViewRepresentable {
    
    var view: UIView
    
    func makeUIView(context: Context) -> UIView {
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    ContentView()
}
