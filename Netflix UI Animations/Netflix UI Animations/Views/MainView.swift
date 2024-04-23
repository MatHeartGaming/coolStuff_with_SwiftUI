//
//  MainView.swift
//  Netflix UI Animations
//
//  Created by Matteo Buompastore on 19/04/24.
//

import SwiftUI

struct MainView: View {
    
    //MARK: - Properties
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            /// Custom Tabs
            CustomTabBar()
        }
        .coordinateSpace(.named("MAINVIEW"))
    }
}

#Preview {
    MainView()
        .environment(AppData())
        .preferredColorScheme(.dark)
}
