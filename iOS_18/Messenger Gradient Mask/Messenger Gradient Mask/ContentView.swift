//
//  ContentView.swift
//  Messenger Gradient Mask
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Messages")
        }
    }
}

#Preview {
    ContentView()
}
