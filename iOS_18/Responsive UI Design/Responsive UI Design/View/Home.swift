//
//  Home.swift
//  Responsive UI Design
//
//  Created by Matteo Buompastore on 19/09/24.
//

import SwiftUI

/// Tabs
enum TabState: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case notifications = "Notifications"
    case profile = "Profile"
    
    var symbolImage: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .notifications: return "bell"
        case .profile: return "person.crop.circle"
        }
    }
}

struct Home: View {
    
    // MARK: Properties
    @State private var activeTab: TabState = .home
    
    /// Gesture
    @State private var panGesture: UIPanGestureRecognizer?
    @State private var offset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    @State private var progress: CGFloat = 0
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        AdaptiveView { size, isLandscape in
            let sideBarWidth: CGFloat = isLandscape ? 220 : 250
            let layout = isLandscape ? AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(ZStackLayout(alignment: .leading))
            NavigationStack(path: $navigationPath) {
                layout {
                    SideBarView(path: $navigationPath) {
                        toggleSideBar()
                    }
                    .frame(width: sideBarWidth)
                    .offset(x: isLandscape ? 0 : -sideBarWidth)
                    .offset(x: isLandscape ? 0 : offset)
                    
                    TabView(selection: $activeTab) {
                        Tab(TabState.home.rawValue, systemImage: TabState.home.symbolImage, value: .home) {
                            Text("Home")
                        }
                        Tab(TabState.search.rawValue, systemImage: TabState.search.symbolImage, value: .search) {
                            Text("Search")
                        }
                        Tab(TabState.notifications.rawValue, systemImage: TabState.notifications.symbolImage, value: .notifications) {
                            Text("Notifications")
                        }
                        Tab(TabState.profile.rawValue, systemImage: TabState.profile.symbolImage, value: .profile) {
                            Text("Profile")
                        }
                    } //: TabView
                    .tabViewStyle(.tabBarOnly)
                    .overlay {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .ignoresSafeArea()
                            .opacity(isLandscape ? 0 : progress)
                    }
                    .offset(x: isLandscape ? 0 : offset)
                } //: ZSTACK
                .gesture(
                    CustomGesture { gesture in
                        if panGesture == nil { panGesture = gesture }
                        let state = gesture.state
                        let translation = gesture.translation(in: gesture.view).x + lastDragOffset
                        let velocity = gesture.velocity(in: gesture.view).x / 3
                        
                        if state == .began || state == .changed {
                            /// On changed
                            offset = max(min(translation, sideBarWidth), 0)
                            
                            /// Storing drag progress, for fading tab view when dragging
                            progress = max(min(offset / sideBarWidth, 1), 0)
                        } else {
                            /// On ended
                            withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                if (velocity + offset) > (sideBarWidth * 0.5) {
                                    /// Expand
                                    offset = sideBarWidth
                                    progress = 1
                                } else {
                                    /// Reset
                                    offset = 0
                                    progress = 0
                                }
                            }
                            
                            lastDragOffset = offset
                        }
                    }
                ) //: Gesture
                .onChange(of: isLandscape) { oldValue, newValue in
                    panGesture?.isEnabled = !newValue
                }
                .navigationDestination(for: String.self) { value in
                    Text("Hello, this is the Detail \(value) View")
                        .navigationTitle(value)
                }
            } //: NAVIGATION
        } //: ADAPTIVE VIEW
    }
    
    private func toggleSideBar() {
        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
            progress = 0
            offset = 0
            lastDragOffset = 0
        }
    }
}

struct SideBarView: View {
    
    @Binding var path: NavigationPath
    var toggleSideBar: () -> Void
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let isSidesHavingValues = safeArea.leading != 0 || safeArea.trailing != 0
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 6) {
                    Image(.pic)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(.circle)
                    
                    Text("Leon S. Kennedy")
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Text("@leonskennedy")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    HStack {
                        Text("1.9K")
                            .fontWeight(.semibold)
                        
                        Text("Following")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Text("3.9M")
                            .fontWeight(.semibold)
                            .padding(.leading, 6)
                        
                        Text("Followers")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                    } //: HSTACK
                    .font(.system(size: 14))
                    .lineLimit(1)
                    .padding(.top, 5)
                    
                    /// SIdebar
                    VStack(alignment: .leading, spacing: 25) {
                        ForEach(SideBarAction.allCases, id: \.rawValue) { action in
                            SideBarActionButton(value: action) {
                                toggleSideBar()
                                path.append(action.rawValue)
                            } //: SideBar Action Button
                        } //: Loop Actions
                    } //: VSTACK
                    .padding(.top, 25)
                    
                } //: VSTACK
                .padding(.vertical, 15)
                .padding(.horizontal, isSidesHavingValues ? 5 : 15)
            } //: V-SCROLL
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .background {
                Rectangle()
                    .fill(.background)
                    .overlay(alignment: .trailing) {
                        Rectangle()
                            .fill(.background)
                            .overlay(alignment: .trailing) {
                                Rectangle()
                                    .fill(.gray.opacity(0.35))
                                    .frame(width: 1)
                            }
                            .ignoresSafeArea()
                    }
            } //: Background
        } //: GEOMETRY
    }
    
    
    @ViewBuilder
    private func SideBarActionButton(value: SideBarAction, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: value.sybmolImage)
                    .font(.title3)
                    .frame(width: 30)
                
                Text(value.rawValue)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
                
            } //: HSTACK
            .foregroundStyle(Color.primary)
            .padding(.vertical, 10)
            .contentShape(.rect)
        }
    }
    
}

/// Side Bar Actions
enum SideBarAction: String, CaseIterable {
    case communities = "Communities"
    case bookmarks = "Bookmarks"
    case lists = "Lists"
    case messages = "Messages"
    case monetization = "Monetization"
    case settings = "Settings"
    
    var sybmolImage: String {
        switch self {
        case .communities: return "person.2"
        case .bookmarks: return "bookmark"
        case .lists: return "list.bullet.clipboard"
        case .messages: return "message.badge.waveform"
        case .monetization: return "banknote"
        case .settings: return "gearshape"
        }
    }
    
}

// MARK: Custom UIKit Pan Gesture
/// Avoids issues with views with scroll
struct CustomGesture: UIGestureRecognizerRepresentable {
    
    var handle: (UIPanGestureRecognizer) -> Void
    
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        handle(recognizer)
    }
    
}


/// Adaptive View
struct AdaptiveView<Content: View>: View {
    
    var showsSideBarOniPadPortrait: Bool = true
    @ViewBuilder var content: (CGSize, Bool) -> Content
    @Environment(\.horizontalSizeClass) private var hClass
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let isLandscape = size.width > size.height || (hClass == .regular && showsSideBarOniPadPortrait)
            
            content(size, isLandscape)
            
        } //: Geometry
    }
    
}


#Preview {
    ContentView()
}
