//
//  ContentView.swift
//  Custom Transitions
//
//  Created by Matteo Buompastore on 19/04/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var showView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    
                    if showView {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.black.gradient)
                            .transition(.reverseFlip)
                    } else {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.red.gradient)
                            .transition(.flip)
                    }
                    
                } //: ZSTACK
                .frame(width: 200, height: 300)
                
                Button(showView ? "Hide" : "Reveal") {
                    withAnimation(.bouncy(duration: 1.5)) {
                        showView.toggle()
                    }
                }
            } //: VSTACK
            .navigationTitle("Custom Transition")
        } //: NAVIGATION
    }
}

struct FlipTransition: ViewModifier, Animatable {
    
    var progress: CGFloat = 0
    
    var animatableData: CGFloat {
        get { return progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(progress < 0 ? (-progress < 0.5 ? 1 : 0) : (progress < 0.5 ? 1 : 0))
            .rotation3DEffect(
                .degrees(progress * 180),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
    }
    
}

extension AnyTransition {
    
    /// Active refers to animating state, while identity to idle state.
    
    static let flip: AnyTransition = .modifier(active: FlipTransition(progress: 1),
                                               identity: FlipTransition())
    
    static let reverseFlip: AnyTransition = .modifier(active: FlipTransition(progress: -1),
                                               identity: FlipTransition())
    
}

#Preview {
    ContentView()
}
