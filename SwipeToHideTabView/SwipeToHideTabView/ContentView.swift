//
//  ContentView.swift
//  SwipeToHideTabView
//
//  Created by Matteo Buompastore on 05/12/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - UI
    @State private var tabState: Visibility = .visible
    
    var body: some View {
        TabView {
            NavigationStack {
                TabStateScrollView(axis: .vertical, showsIndicators: false, tabState: $tabState) {
                    /// Any Scroll content
                    VStack(spacing: 15) {
                        ForEach(1...5, id: \.self) { index in
                            GeometryReader {
                                let size = $0.size
                                
                                Image("bg\(index)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: size.width, height: size.height)
                                    .clipShape(.rect(cornerRadius: 12))
                            } //: GEOMETRY
                            .frame(height: 180)
                        } //: LOOP
                    } //: VSTACK
                    .padding(15)
                    
                    
                } //: TABSTATE
            } //: NAVIGATION
            .toolbar(tabState, for: .tabBar)
            .animation(.easeInOut(duration: 0.3), value: tabState)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            /// Other sample tab
            Text("Favourites")
                .tabItem {
                    Image(systemName: "suit.heart")
                    Text("Favourites")
                }
            
            Text("Notifications")
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            
            Text("Account")
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
            
            
            
        } //: TABVIEW
    }
}

#Preview {
    ContentView()
}
