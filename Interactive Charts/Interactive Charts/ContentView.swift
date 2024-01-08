//
//  ContentView.swift
//  Interactive Charts
//
//  Created by Matteo Buompastore on 08/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Interactive Charts")
        }
    }
}

#Preview {
    ContentView()
}
