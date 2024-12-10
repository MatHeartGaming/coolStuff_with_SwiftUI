//
//  ContentView.swift
//  Expandable Custom Slider
//
//  Created by Matteo Buompastore on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    @State private var volume: CGFloat = 50
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomSlider(value: $volume, in: 0...100) {
                    HStack {
                        Image(systemName: "speaker.wave.3.fill",
                              variableValue: volume / 100)
                        
                        Spacer(minLength: 0)
                        
                        Text(String(format: "%.1f", volume) + "%")
                            .font(.callout)
                    } //: HSTACK
                    .padding(.horizontal, 20)
                } //: Slider
            } //: VSTACK
            .padding(15)
            .navigationTitle("Expandable Slider")
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
