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
        VStack(spacing: 0) {
            Spacer()
            
            /// Custom Tab Bar
            CustomTabBar(activeTab: $activeTab)
            
        } //: VSTACK
        .ignoresSafeArea(.all, edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(.BG)
                .ignoresSafeArea()
        }
        /// Hiding the home view indicator at the bottom
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    Home()
}
