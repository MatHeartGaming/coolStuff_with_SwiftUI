//
//  ContentView.swift
//  GooeyEffect
//
//  Created by Matteo Buompastore on 06/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{ geometry in
            let size = geometry.size
            Home(size: size)
        }
    }
}

#Preview {
    ContentView()
}
