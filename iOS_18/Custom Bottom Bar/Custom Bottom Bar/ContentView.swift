//
//  ContentView.swift
//  Custom Bottom Bar
//
//  Created by Matteo Buompastore on 24/01/25.
//

import SwiftUI

@Observable
class NavigationHelper: NSObject, UIGestureRecognizerDelegate {
    
    var path = NavigationPath()
    var popProgress: CGFloat = 1.0
    
    /// Properties
    private var isAdded: Bool = false
    private var navController: UINavigationController?
    
    func addPopGestureListner(_ controller: UINavigationController) {
        guard !isAdded else { return }
        controller.interactivePopGestureRecognizer?.addTarget(self, action: #selector(didInteractivePopGestureChanged))
        navController = controller
        
        /// Optional
        controller.interactivePopGestureRecognizer?.delegate = self
        
        isAdded = true
    }
    
    @objc
    func didInteractivePopGestureChanged() {
        if let completionProgress = navController?.transitionCoordinator?.percentComplete,
           let state = navController?.interactivePopGestureRecognizer?.state,
           navController?.viewControllers.count == 1 {
            popProgress = completionProgress
            
            if state == .ended || state == .cancelled {
                if completionProgress > 0.5 {
                    /// Popped
                    popProgress = 1
                } else {
                    /// Reset
                    popProgress = 0
                }
            }
        }
    }
    
    /// This will make interactive pop gesture to work even when nav bar is hidden!!!
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        navController?.viewControllers.count ?? 0 > 1
    }
    
}

struct ContentView: View {
    
    // MARK: Properties
    var navigationHelper: NavigationHelper = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            @Bindable var bindableHelper = navigationHelper
            NavigationStack(path: $bindableHelper.path) {
                List {
                    Button {
                        navigationHelper.path.append("Leon")
                    } label: {
                        Text("Leon Kennedy's Post")
                            .foregroundStyle(Color.primary)
                    }
                    
                    /*TextField("Hello", text: .constant(""))
                        /// Apply this directly to the view before any modifier!!!
                        .viewExtractor { view in
                            if let textField = view as? UITextField {
                                print(textField)
                            }
                        }*/

                } //: LIST
                .navigationTitle("Home")
                .navigationDestination(for: String.self) { navTitle in
                    List {
                        Button {
                            navigationHelper.path.append("More Posts")
                        } label: {
                            Text("More Leon S. Kennedy's Post")
                                .foregroundStyle(Color.primary)
                        }
                    }
                    .navigationTitle(navTitle)
                    /// Needs NavigationHelper to conform to UIGestureRecognizerDelegate in order for the PopGesture to work!
                    //.toolbarVisibility(.hidden, for: .navigationBar)
                }
            } //: NAVIGATION
            .viewExtractor { view in
                if let navController = view.next as? UINavigationController {
                    navigationHelper.addPopGestureListner(navController)
                }
            }
            CustomBottomBar()
        } //: VSTACK
        .environment(navigationHelper)
    }
}

struct CustomBottomBar: View {
    
    @Environment(NavigationHelper.self) private var navigationHelper
    @State private var selectedTab: TabModel = .home
    
    var body: some View {
        HStack(spacing: 0) {
            let blur: CGFloat = (1 - navigationHelper.popProgress) * 3
            let scale: CGFloat = (1 - navigationHelper.popProgress) * 0.1
            ForEach(TabModel.allCases, id: \.rawValue) { tab in
                Button {
                    if tab == .newPost {
                        
                    } else {
                        selectedTab = tab
                    }
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(selectedTab == tab || tab == .newPost ? Color.primary : Color.gray)
                        .blur(radius: tab != .newPost ? blur : 0)
                        .scaleEffect(tab == .newPost ? 1.5 : 1 - scale)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .contentShape(.rect)
                }
                .opacity(tab != .newPost ? navigationHelper.popProgress : 1)
                .overlay {
                    ZStack {
                        if tab == .home {
                            Button {
                                
                            } label: {
                                Image(systemName: "exclamationmark.bubble")
                                    .font(.title3)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                        
                        if tab == .settings {
                            Button {
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.title3)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                        
                    } //: ZSTACK
                    .opacity(1 - navigationHelper.popProgress)
                }

            } //: Loop Tabs
        } //: HSTACK
        .onChange(of: navigationHelper.path) { oldValue, newValue in
            guard newValue.isEmpty || oldValue.isEmpty else { return }
            if newValue.count > oldValue.count {
                navigationHelper.popProgress = 0
            } else {
                navigationHelper.popProgress = 1
            }
        }
        .animation(.easeInOut(duration: 0.25), value: navigationHelper.popProgress)
    }
    
}

enum TabModel: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    case newPost = "square.and.pencil.circle.fill"
    case notifications = "bell.fill"
    case settings = "gearshape.fill"
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
