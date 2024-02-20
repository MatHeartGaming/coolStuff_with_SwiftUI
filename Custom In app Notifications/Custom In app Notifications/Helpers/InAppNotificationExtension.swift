//
//  InAppNotificationExtension.swift
//  Custom In app Notifications
//
//  Created by Matteo Buompastore on 20/02/24.
//

import SwiftUI

extension UIApplication {
    
    func inAppNotification<Content: View>(adaptForDynamicIsland: Bool = false, timeout: CGFloat = 0, swipeToClose: Bool = true, @ViewBuilder content: () -> Content) {
        /// Fetching active Window via WindowScene
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == 0320 }) {
            /// Frame and safe area values
            let frame = activeWindow.frame
            let safeArea = activeWindow.safeAreaInsets
            
            /// Once the animation completes is good practice to remove the View from its parent
            var tag: Int = 1009
            
            let checkForDyanamicIsland = adaptForDynamicIsland && safeArea.top >= 51
            
            if let previousTag = UserDefaults.standard.value(forKey: "in_app_notification_tag") as? Int {
                tag = previousTag + 1
            }
            
            UserDefaults.standard.setValue(tag, forKey: "in_app_notification_tag")
            
            /// Changing Status into black to blend with Dynamic Island
            if checkForDyanamicIsland {
                if let controller = activeWindow.rootViewController as? StatusBarBasedController {
                    controller.statusBarStyle = .darkContent
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
            }
            
            /// Creating UIView from SwiftUI View using UIHosting
            let config = UIHostingConfiguration {
                AnimatedNotificationView(
                    content: content(),
                    safeArea: safeArea,
                    tag: tag,
                    adaptForDynamicIsland: adaptForDynamicIsland,
                    timeout: timeout,
                    swipeToClose: swipeToClose
                )
                .frame(width: frame.width - (checkForDyanamicIsland ? 20 : 30), height: 120, alignment: .top)
                .contentShape(.rect)
            }
            
            /// Creating UIView
            let view = config.makeContentView()
            view.tag = tag
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let rootView = activeWindow.rootViewController?.view {
                /// Adding to the window
                rootView.addSubview(view)
                
                /// Layout contraints
                view.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: rootView.centerYAnchor,
                                              constant: (-(frame.height - safeArea.top) / 2) + (checkForDyanamicIsland ? 11 : safeArea.top)).isActive = true
            }
            
        }
    }
    
}

fileprivate struct AnimatedNotificationView<Content: View>: View {
    
    // MARK: - AnimatedNotificationView PROPERTIES
    var content: Content
    var safeArea: UIEdgeInsets
    var tag: Int
    var adaptForDynamicIsland: Bool
    var timeout: CGFloat
    var swipeToClose: Bool
    
    /// UI
    @State private var animateNotification: Bool = false
    
    var body: some View {
        content
            .blur(radius: animateNotification ? 0 : 10)
            .disabled(!animateNotification)
            .mask {
                if adaptForDynamicIsland {
                    /// Size based Capsule
                    GeometryReader { geometry in
                        let size = geometry.size
                        let radius = size.height / 2
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                    }
                } else {
                    Rectangle()
                }
            }
        /// Scaling animation only for Dynamic Island Notificaiton
            .scaleEffect(adaptForDynamicIsland ? (animateNotification ? 1 : 0.01) : 1, anchor: .init(x: 0.5, y: 0.01))
        /// Offset animation for non-Dynamic Island notifications
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        if -value.translation.height > 50 && swipeToClose {
                            finishAnimation()
                        }
                    })
            )
            .onAppear {
                Task {
                    guard !animateNotification else { return }
                    withAnimation(.smooth) {
                        animateNotification = true
                    }
                    
                    /// Timeout for notification
                    try await Task.sleep(for: .seconds(timeout < 1 ? 1 : timeout))
                    
                    guard animateNotification else { return }
                    
                    finishAnimation()
                }
            }
    }
    
    var offsetY: CGFloat {
        if adaptForDynamicIsland {
            return 0
        }
        return animateNotification ? 10 : -(safeArea.top + 130)
    }
    
    
    // MARK: - Functions
    
    private func removeNotificationFromWindow() {
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == 0320 }) {
            if let view = activeWindow.viewWithTag(tag) {
                print("Removed View with tag: \(tag)")
                view.removeFromSuperview()
                
                /// Resetting
                if let controller = activeWindow.rootViewController as? StatusBarBasedController {
                    controller.statusBarStyle = .darkContent
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
                
            }
        }
    }
    
    private func finishAnimation() {
        withAnimation(.smooth, completionCriteria: .logicallyComplete) {
            animateNotification = false
        } completion: {
            removeNotificationFromWindow()
        }
    }
    
}


// MARK: - Preview
#Preview {
    ContentView()
}
