//
//  PinchToZoom.swift
//  Instagram Pinch to Zoom
//
//  Created by Matteo Buompastore on 02/04/24.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func pinchZoom(_ dimsBackground: Bool = true) -> some View {
        PinchZoomHelper(dimsBackground: dimsBackground) {
            self
        }
    }
}

/// Zoom Container. Where the zoom View will be displayed and zoomed
struct ZoomContainer<Content: View>: View {
    
    @ViewBuilder var content: Content
    private var containerData = ZoomContainerData()
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { _ in
            content
                .environment(containerData)
            
            ZStack(alignment: .topLeading) {
                if let view = containerData.zoomingView {
                    Group {
                        if containerData.dimsBackground {
                            Rectangle()
                                .fill(.black.opacity(0.25))
                                .opacity(containerData.zoom - 1)
                        }
                            
                        view
                            .scaleEffect(containerData.zoom, anchor: containerData.zoomAnchor)
                            .offset(containerData.dragOffset)
                            /// View pos
                        .offset(x: containerData.viewRect.minX, y: containerData.viewRect.minY)
                    } //: GROUP
                }
            } //: ZSTACK
            .ignoresSafeArea()
        }
    }
}

fileprivate struct PinchZoomHelper<Content: View>: View {
    
    var dimsBackground: Bool
    @ViewBuilder var content: Content
    
    /// UI
    @Environment(ZoomContainerData.self) private var containerData
    @State private var config: Config = .init()
    
    var body: some View {
        content
            .opacity(config.hidesSourceView ? 0 : 1)
            .overlay(GestureOverlay(config: $config))
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    Color.clear
                        .onChange(of: config.isGestureActive) { oldValue, newValue in
                            if newValue {
                                guard !containerData.isResetting else { return }
                                /// Showing view in Zoom Container
                                containerData.zoomingView = .init(erasing: content)
                                containerData.viewRect = rect
                                containerData.zoomAnchor = config.zoomAnchor
                                containerData.dimsBackground = dimsBackground
                                /// Hiding source view
                                config.hidesSourceView = true
                            } else {
                                containerData.isResetting = true
                                /// Resetting to its inital position with Animation
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                    containerData.dragOffset = .zero
                                    containerData.zoom = 1
                                } completion: {
                                    /// Resetting
                                    config = .init()
                                    /// Remove View from Container View
                                    containerData.zoomingView = nil
                                    containerData.isResetting = false
                                }
                            }
                        }
                        .onChange(of: config) { oldValue, newValue in
                            if config.isGestureActive && !containerData.isResetting {
                                /// Update View position
                                containerData.zoom = config.zoom
                                containerData.dragOffset = config.dragOffset
                            }
                        }
                }
            }
            
    }
}

/// UIKit Gesture overlay
fileprivate struct GestureOverlay: UIViewRepresentable {
    
    @Binding var config: Config
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(config: $config)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        /// Pan Gesture
        let panGesture = UIPanGestureRecognizer()
        panGesture.name = "PINCHPANGESTURE"
        panGesture.minimumNumberOfTouches = 2
        panGesture.addTarget(context.coordinator, action: #selector(Coordinator.panGesture(gesture:)))
        panGesture.delegate = context.coordinator
        view.addGestureRecognizer(panGesture)
        
        /// Pan Gesture
        let pinchGesture = UIPinchGestureRecognizer()
        panGesture.name = "PINCHZOOMGESTURE"
        panGesture.addTarget(context.coordinator, action: #selector(Coordinator.pinchGesture(gesture:)))
        panGesture.delegate = context.coordinator
        view.addGestureRecognizer(pinchGesture)
        
        return view
    }
    
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        @Binding var config: Config
        
        init(config: Binding<Config>) {
            self._config = config
        }
        
        @objc
        func panGesture(gesture: UIPanGestureRecognizer) {
            if gesture.state == .began || gesture.state == .changed {
                let translation = gesture.translation(in: gesture.view)
                config.dragOffset = .init(width: translation.x, height: translation.y)
                config.isGestureActive = true
            } else {
                config.isGestureActive = false
            }
        }
        
        @objc
        func pinchGesture(gesture: UIPinchGestureRecognizer) {
            if gesture.state == .began {
                let location = gesture.location(in: gesture.view)
                if let bounds = gesture.view?.bounds {
                    config.zoomAnchor = .init(x: location.x / bounds.width, y: location.y / bounds.height)
                }
            }
            if gesture.state == .began || gesture.state == .changed {
                let scale = max(gesture.scale, 1)
                config.zoom = scale
                config.isGestureActive = true
            } else {
                config.isGestureActive = false
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecongnizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer.name == "PINCHPANGESTURE" && otherGestureRecongnizer.name == "PINCHZOOMGESTURE" {
                return true
            }
            return false
        }
        
    }
    
}

/// Observable clas to share data between Container and its inner View
@Observable
fileprivate class ZoomContainerData {
    var zoomingView: AnyView?
    var viewRect: CGRect = .zero
    var dimsBackground: Bool = false
    /// UI
    var zoom: CGFloat = 1
    var zoomAnchor: UnitPoint = .center
    var dragOffset: CGSize = .zero
    var isResetting: Bool = false
}

/// Configs
fileprivate struct Config: Equatable {
    var isGestureActive: Bool = false
    var zoom: CGFloat = 1
    var zoomAnchor: UnitPoint = .center
    var dragOffset: CGSize = .zero
    var hidesSourceView: Bool = false
}

#Preview {
    ContentView()
}
