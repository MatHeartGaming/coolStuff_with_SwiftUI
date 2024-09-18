//
//  PopView.swift
//  Alert Dialogs
//
//  Created by Matteo Buompastore on 18/09/24.
//

import SwiftUI

/// Config
struct Config {
    
    var backgroundColor: Color = .black.opacity(0.25)
    
}

extension View {
    
    @ViewBuilder
    func popView<Content: View>(
        config: Config = .init(),
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .modifier(PopViewHelper(config: config,
                                    isPresented: isPresented,
                                    onDismiss: onDismiss,
                                    viewContent: content))
    }
}

fileprivate struct PopViewHelper<ViewContent: View>: ViewModifier {
    
    var config: Config
    @Binding var isPresented: Bool
    var onDismiss: () -> Void
    @ViewBuilder var viewContent: ViewContent
    
    /// UI
    @State private var presentFullScreenCover: Bool = false
    @State private var animateView: Bool = false
    
    func body(content: Content) -> some View {
        /// Unmutable Properties (To suppress the main actor-isolated Swift 6 warning)
        let screenHight = screenSize.height
        let animateView = animateView
        content
            .fullScreenCover(isPresented: $isPresented, onDismiss: onDismiss) {
                ZStack {
                    Rectangle()
                        .fill(config.backgroundColor)
                        .ignoresSafeArea()
                        .opacity(animateView ? 1 : 0)
                    viewContent
                        .visualEffect({ content, proxy in
                            content
                                .offset(y: offset(proxy,
                                                  screenHeight: screenHight,
                                                  animateView: animateView))
                        })
                        .presentationBackground(.clear)
                        .task {
                            guard !animateView else { return }
                            withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
                                self.animateView = true
                            }
                        }
                        .ignoresSafeArea(.container, edges: .all)
                } //: ZSTACK
            }
            .onChange(of: presentFullScreenCover) { oldValue, newValue in
                if newValue {
                    toggleView(true)
                } else {
                    Task {
                        withAnimation(.snappy(duration: 0.45, extraBounce: 0)) {
                            self.animateView = false
                        } completion: {
                            toggleView(false)
                        }
                        
                        /// Using animation completion instead
                        //try? await Task.sleep(for: .seconds(0.45))
                    }
                }
            }
    }
    
    
    // MARK: Functions
    
    func toggleView(_ status: Bool) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            presentFullScreenCover = status
        }
    }
    
    nonisolated private func offset(_ proxy: GeometryProxy, screenHeight: CGFloat, animateView: Bool) -> CGFloat {
        let viewHeight = proxy.size.height
        
        return animateView ? 0 : (screenHeight + viewHeight) / 2
    }
    
    var screenSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        return .zero
    }
    
}

struct PopView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    PopView()
}

#Preview {
    ContentView()
}
