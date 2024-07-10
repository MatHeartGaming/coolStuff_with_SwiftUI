//
//  ContentView.swift
//  Removing More Button TabBar
//
//  Created by Matteo Buompastore on 10/07/24.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    case notifications = "bell.fill"
    case bookmarks = "bookmark.fill"
    case communities = "person.3.fill"
    case settings = "gearshape.fill"
    
}

struct ContentView: View {
    
    // MARK: Properties
    @State private var activeTab: TabModel = .home
    @State private var isHidden: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                Tab(value: .home) {
                    Text("Home")
                        .toolbarVisibility(.hidden, for: .tabBar)
                        .background {
                            if !isHidden {
                                RemoveMoreNavigationBar {
                                    isHidden = true
                                }
                            }
                        }
                }
                Tab(value: .search) {
                    Text("Search")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab(value: .notifications) {
                    Text("Notifications")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab(value: .bookmarks) {
                    Text("Bookmarks")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab(value: .communities) {
                    Text("Communities")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab(value: .settings) {
                    Text("Settings")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
            }
            CustomTabBar()
        } //: VSTACK
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(TabModel.allCases, id: \.rawValue) { tab in
                Button {
                    activeTab = tab
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(activeTab == tab ? Color.primary : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .contentShape(.rect)
                }
            } //: Loop tabs
        } //: HSTACK
    }
}

/// This also works on iOS 16+
struct RemoveMoreNavigationBar: UIViewRepresentable {
    
    var result: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let tabBarController = view.tabBarController {
               tabBarController.moreNavigationController.navigationBar.isHidden = true
                result()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

/// Finding Attached UITabBarController from UIView
extension UIView {
    
    var tabBarController: UITabBarController? {
        if let controller = sequence(first: self, next: { item in
            item.next
        }).first(where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }
        return nil
    }
    
}

#Preview {
    ContentView()
}
