//
//  ContentView.swift
//  DeepLinksApp
//
//  Created by Matteo Buompastore on 11/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

#Preview {
    ContentView()
        .environmentObject(AppData())
}
