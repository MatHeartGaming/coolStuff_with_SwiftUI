//
//  ContentView.swift
//  ParticleEffect
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ImagePicker(title: "Drag & Drop", subTitle: "Or tap to add an image", systemImage: "square.and.arrow.up", tint: .blue) { image in
                    print(image)
                }
                .frame(maxWidth: 300, maxHeight: 250)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Image Picker")
        }
    }
}

#Preview {
    ContentView()
}
