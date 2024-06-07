//
//  ContentView.swift
//  Glitch Text Effect
//
//  Created by Matteo Buompastore on 07/06/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State private var trigger: (Bool, Bool , Bool) = (false, false, false)
    
    var body: some View {
        VStack {
            GlitchTextView("Hello Guys!", trigger: trigger.0)
                .font(.system(size: 50, weight: .semibold))
            GlitchTextView("This is a", trigger: trigger.1)
                .font(.system(size: 30, design: .rounded))
            GlitchTextView("Glitch Text Effect", trigger: trigger.2)
                .font(.system(size: 20, weight: .semibold))
            
            Button(action: {
                Task {
                    trigger.0.toggle()
                    try? await Task.sleep(for: .seconds(0.5))
                    trigger.1.toggle()
                    try? await Task.sleep(for: .seconds(0.5))
                    trigger.2.toggle()
                }
            }, label: {
                Text("Trigger")
                    .padding(.horizontal, 15)
            })
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.black)
            .clipShape(.capsule)
            .padding(.top, 20)
        } //: VSTACK
        .padding()
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private func GlitchTextView(_ text: String, trigger: Bool) -> some View {
        ZStack {
            
            GlitchText(text: text, trigger: trigger) {
                LinearKeyframe(
                    GlitchFrame(top: -5, center: 0, bottom: 0, shadowOpacity: 0.2),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: -5, center: -5, bottom: -5, shadowOpacity: 0.6),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: -5, center: 0, bottom: 5, shadowOpacity: 0.8),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 5, bottom: 5, shadowOpacity: 0.4),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 0, bottom: 5, shadowOpacity: 0.1),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(),
                    duration: 0.1
                )
                
            } //: Glitch Text
            
            GlitchText(text: text, trigger: trigger, shadow: .green) {
                LinearKeyframe(
                    GlitchFrame(top: 0, center: 5, bottom: 0, shadowOpacity: 0.2),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 5, bottom: 5, shadowOpacity: 0.3),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 5, bottom: -5, shadowOpacity: 0.5),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 0, center: 5, bottom: -5, shadowOpacity: 0.6),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 0, center: -5, bottom: 0, shadowOpacity: 0.3),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(),
                    duration: 0.1
                )
                
            } //: Glitch Text
            
        } //: ZSTACK
    }
    
}

#Preview {
    ContentView()
}
