//
//  ContentView.swift
//  Platform Specific Views And Files
//
//  Created by Matteo Buompastore on 22/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        /*VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .platform(.iOS) { view in
            view
                .padding(25)
                .background(.red)
        }
        .platform(.macOS) { view in
            view
                .padding(10)
                .background(.blue)
        }*/
        //BlurView()
        Home()
    }
}

#Preview {
    ContentView()
}
