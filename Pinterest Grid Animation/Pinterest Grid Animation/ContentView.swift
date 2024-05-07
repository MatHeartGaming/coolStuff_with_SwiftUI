//
//  ContentView.swift
//  Pinterest Grid Animation
//
//  Created by Matteo Buompastore on 07/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .toolbar(.hidden, for: .navigationBar)
        }  //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
