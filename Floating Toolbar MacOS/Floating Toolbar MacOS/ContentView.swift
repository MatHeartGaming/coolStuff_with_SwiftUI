//
//  ContentView.swift
//  Floating Toolbar MacOS
//
//  Created by Matteo Buompastore on 19/01/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @StateObject private var tabModel = TabModel()
    @Environment(\.controlActiveState) private var state
    
    var body: some View {
        TabView(selection: $tabModel.activeTab) {
            NavigationStack {
                Text("Home View")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("", systemImage: "sidebar.left") {
                                tabModel.hideTabBar.toggle()
                            }
                        }
                    }
            }
            .tag(Tab.home)
            .background(HideTabBar())
            
            Text("Favourites View")
                .tag(Tab.favourites)
                .background(HideTabBar())
            
            Text("Notification View")
                .tag(Tab.notifications)
                .background(HideTabBar())
                     
            Text("Settings View")
                .tag(Tab.settings)
                .background(HideTabBar())
            
        } //: TABVIEW
        //.onAppear(perform: tabModel.addTabBar) // Already present in custom onChange
        .opacity(tabModel.isTabBarAdded ? 1 : 0)
        .background {
            GeometryReader {
                let rect = $0.frame(in: .global)
                let _ = print(rect.size.width)
                Color.clear
                    .customOnChange(value: rect) { _ in
                        /// Frame changed
                        tabModel.updateTabPosition()
                    }
            }
        }
        .customOnChange(value: state, initial: true) { newValue in
            if newValue == .key {
                tabModel.addTabBar()
            }
        }
        .frame(minWidth: 100, minHeight: 250)
        .padding(.bottom, tabModel.isTabBarAdded ? 0 : 1)
        
    }
}


extension View {
    
    @ViewBuilder
    func customOnChange<Value: Equatable>(value: Value, initial: Bool = false, result: @escaping (Value) -> Void) -> some View {
        if #available(macOS 14, *) {
            self
                .onChange(of: value, initial: initial) { oldValue, newValue in
                    result(newValue)
                }
        } else {
            self
                .onChange(of: value, perform: result)
                .onAppear {
                    if initial {
                        result(value)
                    }
                }
        }
    }
    
    @ViewBuilder
    func windowBackground() -> some View {
        if #available(macOS 14, *) {
            self
                .background(.windowBackground)
        } else {
            self
                .background(.background)
        }
    }
    
}


class TabModel: ObservableObject {
    @Published var activeTab: Tab = .home
    @Published var isTabBarAdded: Bool = false
    @Published var hideTabBar: Bool = false
    private let id: String = UUID().uuidString
    
    func addTabBar() {
        guard !isTabBarAdded else { return }
        if let applicationWindow = NSApplication.shared.mainWindow {
            let customTabBar = NSHostingView(
                rootView: FloatingTabBarView()
                    .environmentObject(self)
            )
            let floatingWindow = NSWindow()
            floatingWindow.styleMask = .borderless
            floatingWindow.contentView = customTabBar
            floatingWindow.backgroundColor = .clear
            floatingWindow.title = id
            
            /// Get window size
            let windowSize = applicationWindow.frame.size
            let windowOrigin = applicationWindow.frame.origin
            
            floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 50, y: windowOrigin.y + (windowSize.height - 180) / 2))
            
            /// Adding above the application Window
            applicationWindow.addChildWindow(floatingWindow, ordered: .above)
            
            /// Prevents the tab bar being added more than once in some scenarios
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                self?.isTabBarAdded = true
            }
            
            
            
        } else {
            print("No Window found!")
        }
    }
    
    func updateTabPosition() {
        if let floatingWindow = NSApplication.shared.windows.first(where: { $0.title == id }),
           let applicationWindow = NSApplication.shared.mainWindow {
            /// Get window size
            let windowSize = applicationWindow.frame.size
            let windowOrigin = applicationWindow.frame.origin
            
            floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 50, y: windowOrigin.y + (windowSize.height - 180) / 2))
        }
    }
    
}

enum Tab: String, CaseIterable {
    
    case home = "house.fill"
    case favourites = "suit.heart.fill"
    case notifications = "bell.fill"
    case settings = "gearshape"
    
}


fileprivate struct FloatingTabBarView: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject private var tabModel: TabModel
    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var animation
    private let animationID = UUID()
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {tab in
                Button {
                    tabModel.activeTab = tab
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(tabModel.activeTab == tab ? (colorScheme == .dark ? .black : .white) : .primary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            if tabModel.activeTab == tab {
                                Circle()
                                    .fill(.primary)
                                    /// To give the sliding animation
                                    .matchedGeometryEffect(id: animationID, in: animation)
                            }
                        } //: IMAGE
                        .contentShape(.rect)
                        .animation(.bouncy, value: tabModel.activeTab)
                } //: BUTTON
                .buttonStyle(.plain)
            } //: LOOP TABS
        } //: VSTACK
        .padding(5)
        .frame(width: 45, height: 180)
        .windowBackground()
        .clipShape(.capsule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: 50)
        .contentShape(.capsule)
        .offset(x: tabModel.hideTabBar ? 60 : 0)
        .animation(.snappy, value: tabModel.hideTabBar)
    }
    
}

/// Hiding MacOS TabBar
fileprivate struct HideTabBar: NSViewRepresentable {
    
    func makeNSView(context: Context) -> some NSView {
        return .init()
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let tabView = nsView.superview?.superview?.superview as? NSTabView {
                tabView.tabViewType = .noTabsNoBorder
                tabView.tabViewBorderType = .none
                tabView.tabPosition = .none
            }
        }
    }
    
}

#Preview {
    ContentView()
}
