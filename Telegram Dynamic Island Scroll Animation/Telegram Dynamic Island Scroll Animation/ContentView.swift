//
//  ContentView.swift
//  Telegram Dynamic Island Scroll Animation
//
//  Created by Matteo Buompastore on 11/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea()
            
            
        } //: GEOMETRY
    }
}

#Preview {
    ContentView()
}
