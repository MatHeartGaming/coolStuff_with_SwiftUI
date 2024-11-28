//
//  ContentView.swift
//  SwiftUIView Snapshots
//
//  Created by Matteo Buompastore on 28/11/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var trigger: Bool = false
    @State private var snapshot: UIImage?
    
    var body: some View {
        VStack(spacing: 25) {
            Button("Take a snapshot") {
                trigger.toggle()
            }
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                
                Text("Hello World")
            } //: VSTACK
            .foregroundStyle(.white)
            .padding()
            .background(.red.gradient, in: .rect(cornerRadius: 15))
            .snapshot(trigger: trigger) { image in
                snapshot = image
            }
            
            if let snapshot {
                Image(uiImage: snapshot)
                    .scaledToFit()
            }
        } //: VSTACK
    }
}

#Preview {
    ContentView()
}
