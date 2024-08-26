//
//  ContentView.swift
//  Custom Time Picker Apple Timer
//
//  Created by Matteo Buompastore on 28/06/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State var hour: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                TimePicker(hour: $hour, minutes: $minutes, seconds: $seconds)
                    .padding(15)
                    .background(.white, in: .rect(cornerRadius: 10))
                    .padding(.horizontal, 20)
            } //: VSTACK
            .padding(15)
            .navigationTitle("Custom Time Picker")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.15))
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
