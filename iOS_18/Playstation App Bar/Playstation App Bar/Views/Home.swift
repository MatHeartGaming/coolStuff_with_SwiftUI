//
//  Home.swift
//  Playstation App Bar
//
//  Created by Matteo Buompastore on 18/01/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - PROPERTIES
    @State private var activeTab: Tab = .play
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabHostView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBar(activeTab: $activeTab)
        } //: ZSTACK
        .ignoresSafeArea(.all, edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(.BG)
                .ignoresSafeArea()
        }
        /// Hiding the home view indicator at the bottom
        .persistentSystemOverlays(.hidden)
        .overlay {
            GeometryReader {
                let size = $0.size
                
                CustomHeaderView(size: size)
            }
        }
    }
}

#Preview {
    Home()
}
