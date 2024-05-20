//
//  ContentView.swift
//  Stacked Scroll View
//
//  Created by Matteo Buompastore on 20/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader { _ in
                
                Image(.wallpaper)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
            } //: GEOMETRY
            
            Home()
        } //: ZSTACK
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    ContentView()
}
