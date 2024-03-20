//
//  ContentView.swift
//  Long Press Button ProgressBar
//
//  Created by Matteo Buompastore on 20/03/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var count: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(count)")
                    .font(.largeTitle.bold())
                
                HoldDownButton(
                    text: "Hold to Increase",
                    duration: 0.5,
                    background: .black,
                    loadingTint: .white.opacity(0.3)) {
                    count += 1
                }
                .padding(.top, 45)
                .foregroundStyle(.white)
                
            } //: VSTACK
            .padding()
            .navigationTitle("Hold Down Button")
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
