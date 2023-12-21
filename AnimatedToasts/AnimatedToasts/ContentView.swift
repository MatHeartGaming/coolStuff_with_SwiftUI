//
//  ContentView.swift
//  AnimatedToasts
//
//  Created by Matteo Buompastore on 21/12/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - UI

    var body: some View {
        VStack {
            Button("Present Toast") {
                Toast.shared.present(title: "Hello World", 
                                     symbol: "airpodspro",
                                     isUserInteractionEnabled: true,
                                     timing: .long
                )
            }
        }
        .padding()
    }
}

#Preview {
    RootView {
        ContentView()
    }
}
