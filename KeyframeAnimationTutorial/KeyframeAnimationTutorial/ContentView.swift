//
//  ContentView.swift
//  KeyframeAnimationTutorial
//
//  Created by Matteo Buompastore on 22/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomButton(buttonTint: .gray) {
            HStack(spacing: 10) {
                Text("Login")
                Image(systemName: "chevron.right")
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
        } action: {
            let seconds = Int.random(in: 0...3)
            try? await Task.sleep(for: .seconds(seconds))
            return .failed("Password Incorrect")
        }
        .buttonStyle(.opacityLess)

    }
}

#Preview {
    ContentView()
}
