//
//  ContentView.swift
//  Netflix UI Animations
//
//  Created by Matteo Buompastore on 19/04/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    var appData: AppData = .init()
    
    var body: some View {
        ZStack {
            
            MainView()
            
            if !appData.isSplashFinished {
                SplashScreen()
            }
        } //: ZSTACK
        .environment(appData)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environment(AppData())
        .preferredColorScheme(.dark)
}
