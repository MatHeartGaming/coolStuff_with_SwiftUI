//
//  ContentView.swift
//  Interactive Tab Bar
//
//  Created by Matteo Buompastore on 22/01/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var activeTab: TabItem = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $activeTab) {
                    ForEach(TabItem.allCases, id: \.rawValue) { tab in
                        Tab.init(value: tab) {
                            Text(tab.rawValue)
                                /// Hide the native Tab Bar
                                .toolbarVisibility(.hidden, for: .tabBar)
                        } //: Tab
                    } //: Loop Items
                } //: TABVIEW
            } else {
                TabView(selection: $activeTab) {
                    ForEach(TabItem.allCases, id: \.rawValue) { tab in
                            Text(tab.rawValue)
                                .tag(tab)
                                /// Hide the native Tab Bar
                                .toolbarVisibility(.hidden, for: .tabBar)
                    } //: Loop Items
                } //: TABVIEW
            }
            
            //InteractiveTabBar(activeTab: $activeTab)
            FloatingInteractiveTabBar(activeTab: $activeTab)
        } //: ZSTACK
    }
}

/// Interactive Tab Bar
struct InteractiveTabBar: View {
    
    @Binding var activeTab: TabItem
    @Namespace private var animation
    
    /// Storing location of Tab Buttons so that they can be used to identify currently dragged tab
    @State private var tabButtonsLocations: [CGRect] = Array(repeating: .zero, count: TabItem.allCases.count)
    
    /// By using this we can animate changes in Tab Bar without animating the actual TabView.
    @State private var activeDraggingTab: TabItem?
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabButton(tab)
            } //: Loop Tab Items
        } //: HSTACK
        .frame(height: 70)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background {
            Rectangle()
                .fill(.background.shadow(.drop(color: .primary.opacity(0.2), radius: 5)))
                .ignoresSafeArea()
                .padding(.top, 20)
        }
        .coordinateSpace(.named("TABBAR"))
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func TabButton(_ tab: TabItem) -> some View {
        let isActive = (activeDraggingTab ?? activeTab) == tab
        
        VStack(spacing: 6) {
            Image(systemName: tab.symbolImageName)
                .symbolVariant(.fill)
                .frame(width: isActive ? 50 : 25, height: isActive ? 50 : 25)
                .background {
                    if isActive {
                        Circle()
                            .fill(.blue.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
                /// To give elevation to push the active Tab
                .frame(width: 25, height: 25, alignment: .bottom)
                /// Make it interactive
                .contentShape(.rect)
                //.padding(isActive ? 20 : 0)
                .foregroundStyle(isActive ? .white : .primary)
            
            Text(tab.rawValue)
                .font(.caption2)
                .foregroundStyle(isActive ? .blue : .gray)
            
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .onGeometryChange(for: CGRect.self, of: {
            $0.frame(in: .named("TABBAR"))
        }, action: { newValue in
            tabButtonsLocations[tab.index] = newValue
        })
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy) {
                activeTab = tab
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .named("TABBAR"))
                .onChanged { value in
                    let location = value.location
                    /// Checking if location falls within any stored location.
                    /// If so we swtich to the appropriate index
                    if let index = tabButtonsLocations.firstIndex(where: { $0.contains(location) }) {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                            activeDraggingTab = TabItem.allCases[index]
                        }
                    }
                }.onEnded { _ in
                    /// Push changes to actual Tab View
                    if let activeDraggingTab {
                        activeTab = activeDraggingTab
                    }
                    activeDraggingTab = nil
                },
            /// This becomes false as soon as one tab is moved... So we use the actual tab value instead of isActive here
            isEnabled: activeTab == tab
        )
    }
    
}

/// Interactive Tab Bar
struct FloatingInteractiveTabBar: View {
    
    @Binding var activeTab: TabItem
    @Namespace private var animation
    
    /// Storing location of Tab Buttons so that they can be used to identify currently dragged tab
    @State private var tabButtonsLocations: [CGRect] = Array(repeating: .zero, count: TabItem.allCases.count)
    
    /// By using this we can animate changes in Tab Bar without animating the actual TabView.
    @State private var activeDraggingTab: TabItem?
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabButton(tab)
            } //: Loop Tab Items
        } //: HSTACK
        .frame(height: 40)
        .padding(5)
        .background {
            Capsule()
                .fill(.background.shadow(.drop(color: .primary.opacity(0.2), radius: 5)))
        }
        .coordinateSpace(.named("TABBAR"))
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func TabButton(_ tab: TabItem) -> some View {
        let isActive = (activeDraggingTab ?? activeTab) == tab
        
        VStack(spacing: 6) {
            Image(systemName: tab.symbolImageName)
                .symbolVariant(.fill)
                .foregroundStyle(isActive ? .white : .primary)
            
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            if isActive {
                Capsule()
                    .fill(.blue.gradient)
                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
            }
        }
        .onGeometryChange(for: CGRect.self, of: {
            $0.frame(in: .named("TABBAR"))
        }, action: { newValue in
            tabButtonsLocations[tab.index] = newValue
        })
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy) {
                activeTab = tab
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .named("TABBAR"))
                .onChanged { value in
                    let location = value.location
                    /// Checking if location falls within any stored location.
                    /// If so we swtich to the appropriate index
                    if let index = tabButtonsLocations.firstIndex(where: { $0.contains(location) }) {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                            activeDraggingTab = TabItem.allCases[index]
                        }
                    }
                }.onEnded { _ in
                    /// Push changes to actual Tab View
                    if let activeDraggingTab {
                        activeTab = activeDraggingTab
                    }
                    activeDraggingTab = nil
                },
            /// This becomes false as soon as one tab is moved... So we use the actual tab value instead of isActive here
            isEnabled: activeTab == tab
        )
    }
    
}

enum TabItem: String, CaseIterable {
    
    case home = "Home"
    case search = "Search"
    case notifications = "Notifications"
    case settings = "Settings"
    
    var symbolImageName: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
        case .notifications:
            return "bell"
        case .settings:
            return "gearshape"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
    
}

#Preview {
    ContentView()
}
