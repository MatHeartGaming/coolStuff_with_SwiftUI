//
//  Toast.swift
//  AnimatedToasts
//
//  Created by Matteo Buompastore on 21/12/23.
//

import SwiftUI

/// Root View for creating overlay window

struct RootView<Content: View>: View {
    
    // MARK: - UI
    @ViewBuilder var content: Content
    
    @State private var overlayWindow: UIWindow?
    
    var body: some View {
        content
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   overlayWindow == nil {
                    let window = PassthroughWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    
                    /// View Controller
                    let rootViewController = UIHostingController(rootView: ToastGroup())
                    rootViewController.view.frame = windowScene.keyWindow?.frame ?? .zero
                    rootViewController.view.backgroundColor = .clear
                    window.rootViewController = rootViewController
                    
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = windowSceneTag
                    
                    overlayWindow = window
                }
            }
    }
    
}


fileprivate class PassthroughWindow: UIWindow {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        
        return rootViewController?.view == view ? nil : view
    }
    
}

@Observable
class Toast {
    static let shared = Toast()
    
    fileprivate var toasts = [ToastItem]()
    
    func present(title: String, symbol: String?, tint: Color = .primary, isUserInteractionEnabled: Bool = false, timing: ToastTime = .medium) {
        withAnimation(.snappy) {
            toasts.append(.init(title: title, symbol: symbol, tint: tint, isUserInteractionEnabled: isUserInteractionEnabled, timing: timing))
        }
    }
    
}

struct ToastItem: Identifiable {
    
    let id = UUID()
    var title: String
    var symbol: String?
    var tint: Color
    var isUserInteractionEnabled: Bool
    
    /// Timing
    var timing: ToastTime = .medium
    
    
}

enum ToastTime: CGFloat {
    case short = 1.0
    case medium = 2.0
    case long = 3.5
}

fileprivate struct ToastGroup: View {
    
    var model = Toast.shared
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                
                ForEach(model.toasts) { toast in
                    ToastView(size: size, item: toast)
                        .scaleEffect(scale(toast))
                        .offset(y: offsetY(toast))
                        .zIndex(Double(model.toasts.firstIndex(where: { $0.id == toast.id })  ?? 0))
                }
                
            } //: ZSTACK
            .padding(.bottom, safeArea.top == .zero ? 15 : 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    private func offsetY(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        
        return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
    }
    
    private func scale(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        
        return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
    }
    
}


fileprivate struct ToastView: View {
    
    var size: CGSize
    var item: ToastItem
    
    /// View properties
    @State private var animateIn: Bool = false
    @State private var animateOut: Bool = false
    @State private var delayTask: DispatchWorkItem?
    
    var body: some View {
        HStack(spacing: 0) {
            if let symbol = item.symbol {
                Image(systemName: symbol)
                    .font(.title3)
                    .padding(.trailing, 10)
            }
            
            //Text(item.title)
            Text(item.title)
        } //: HSTACK
        .foregroundStyle(item.tint)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(
            .background
                .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
                .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5)),
            in: .capsule
        ) //: BACKGROUND
        .contentShape(.capsule)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded({ value in
                    guard item.isUserInteractionEnabled else { return }
                    let endY = value.translation.height
                    let velocityY = value.velocity.height
                    
                    if (endY + velocityY) > 100 {
                        removeToast()
                    }
                })
        )
        //.offset(y: animateIn ? 0 : 150)
        //.offset(y: !animateOut ? 0 : 150)
        /*.task {
            /*guard !animateIn else { return }
            withAnimation(.snappy) {
                animateIn = true
            }*/
            
            try? await Task.sleep(for: .seconds(item.timing.rawValue))
            
            removeToast()
        }*/
        .onAppear {
            delayTask = .init(block: {
                removeToast()
            })
            
            if let delayTask {
                DispatchQueue.main.asyncAfter(deadline: .now() + item.timing
                    .rawValue, execute: delayTask)
            }
        }
        /// Limting size
        .frame(maxWidth: size.width * 0.7)
        .transition(.offset(y: 150))
    }
    
    
    
    private func removeToast() {
        if let delayTask {
            delayTask.cancel()
        }
        withAnimation(.snappy) {
            Toast.shared.toasts.removeAll(where: { $0.id == item.id })
        }
    }
    
    /*private func removeToast() {
        guard !animateOut else { return }
        
        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
            animateOut = true
        } completion: {
            removeToastItem()
        }
    }
    
    private func removeToastItem() {
        Toast.shared.toasts.removeAll(where: { $0.id == item.id })
    }*/
    
}


#Preview(traits: .sizeThatFitsLayout) {
//    ToastView(size: .init(width: 100, height: 50), item: .init(title: "Prova", 
//                                                               tint: .gray.opacity(0.5),
//                                                               isUserInteractionEnabled: true))
    RootView {
        ContentView()
    }
}
