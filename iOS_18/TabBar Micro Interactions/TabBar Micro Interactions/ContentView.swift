//
//  ContentView.swift
//  TabBar Micro Interactions
//
//  Created by Matteo Buompastore on 21/11/24.
//

import SwiftUI

/// Type 2
@Observable
class TabBarData {
    var hideTabBar: Bool = false
}

struct ContentView: View {
    
    // MARK: Properties
    @State private var activeTab: TabValue = .home
    @State private var symbolEffectTrigger: TabValue?
    
    /// Type 1
    //@SceneStorage("hideTabBar") private var hideTabBar: Bool = false
    var tabBarData = TabBarData()
    
    var body: some View {
        TabView(selection: .init(get: {
            return activeTab
        }, set: { newValue in
            activeTab = newValue
            symbolEffectTrigger = newValue
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                symbolEffectTrigger = nil
            }
        })) {
            Tab.init(value: .home) {
                TextField("Message", text: .constant(""))
                //DummyScrollView()
                    .overlay(alignment: .topTrailing) {
                        Button("Hide Tab Bar") {
                            tabBarData.hideTabBar.toggle()
                        }
                        .foregroundStyle(.white)
                        .padding(25)
                    }
                    .toolbarVisibility(tabBarData.hideTabBar ? .hidden : .visible, for: .tabBar)
                    
            } //: Home Tab
            Tab.init(value: .search) {
                Text("Search")
            } //: Search Tab
            Tab.init(value: .settings) {
                Text("Settings")
            } //: Settings Tab
        } //: TabView
        .overlay(alignment: .bottom) {
            AnimatedTabBar()
                .opacity(tabBarData.hideTabBar ? 0 : 1)
        }
        .environment(tabBarData)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
    
    /// Views
    
    @ViewBuilder
    private func AnimatedTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(TabValue.allCases, id: \.rawValue) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.symbolImage)
                        .font(.title2)
                        .symbolVariant(.fill)
                        .modifiers { content in
                            switch tab {
                            case .home:
                                content
                                    .symbolEffect(.bounce.byLayer.down, options: .speed(1.2), value: symbolEffectTrigger == tab)
                            case .search:
                                content
                                    .symbolEffect(.wiggle.counterClockwise, options: .speed(1.4), value: symbolEffectTrigger == tab)
                            case .settings:
                                content
                                    .symbolEffect(.rotate.byLayer, options: .speed(2), value: symbolEffectTrigger == tab)
                            }
                        }
                    Text(tab.rawValue)
                        .font(.caption2)
                        
                } //: VSTACK
                .foregroundStyle(activeTab == tab ? .blue : .secondary)
                .frame(maxWidth: .infinity)
            } //: Loop Tabs
        } //: HSTACK
        .allowsHitTesting(false)
        .frame(height: 48)
    }
    
    @ViewBuilder
    private func DummyScrollView() -> some View {
        ScrollView {
            VStack {
                ForEach(1...50, id: \.self) { _ in
                    Rectangle()
                        .frame(height: 50)
                }
            } //: VSTACK
            .padding()
        } //: SCROLL
    }
    
}

extension View {
    @ViewBuilder
    func modifiers<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}

enum TabValue: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case settings = "Settings"
    
    var symbolImage: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .settings: return "gearshape"
        }
    }
}

#Preview {
    ContentView()
}
