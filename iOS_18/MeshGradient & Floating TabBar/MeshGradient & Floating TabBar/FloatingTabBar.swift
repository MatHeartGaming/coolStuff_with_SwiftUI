//
//  FloatingTabBar.swift
//  MeshGradient & Floating TabBar
//
//  Created by Matteo Buompastore on 17/06/24.
//

import SwiftUI

struct FloatingTabBar: View {
    var body: some View {
        TabView {
            Tab.init("Home", systemImage: "house.fill") {
                
            }
            Tab.init("Search", systemImage: "magnifyingglass", role: .search) {
                
            }
            Tab.init("Notifications", systemImage: "bell.fill") {
                
            }
            Tab.init("Settings", systemImage: "gearshape") {
                
            }
        } //: TABVIEW
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    FloatingTabBar()
}
