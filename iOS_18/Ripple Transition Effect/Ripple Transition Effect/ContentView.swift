//
//  ContentView.swift
//  Ripple Transition Effect
//
//  Created by Matteo Buompastore on 24/02/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var count: Int = 0
    @State private var rippleLocation: CGPoint = .zero
    @State private var showOverlayView: Bool = false
    @State private var overlayRippleLocation: CGPoint = .zero
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader {
                    let size = $0.size
                    
                    ForEach(0...1, id: \.self) { index in
                        if (index == count) {
                            imageView(index, size: size)
                                .transition(.ripple(location: rippleLocation))
                        }
                    }
                    
                } //: GEOMETRY
                .frame(width: 350, height: 500)
                .coordinateSpace(.named("VIEW"))
                .onTapGesture(count: 1, coordinateSpace: .named("VIEW")) { location in
                    rippleLocation = location
                    withAnimation(.linear(duration: 1)) {
                        count = (count + 1) % 2
                    }
                }
            } //: VSTACK
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                GeometryReader {
                    let frame = $0.frame(in: .global)
                    
                    Button {
                        overlayRippleLocation = .init(x: frame.midX, y: frame.midY)
                        withAnimation(.linear(duration: 1)) {
                            showOverlayView = true
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                            .background(.indigo.gradient, in: .circle)
                            .contentShape(.rect)
                    }
                } //: GEOMETRY
                .frame(width: 50, height: 50)
                .padding(15)
            }
            .navigationTitle("Ripple Transition")
        } //: NAVIGATION
        .overlay {
            if showOverlayView {
                ZStack {
                    Rectangle()
                        .fill(.indigo.gradient)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.55)) {
                                showOverlayView = false
                            }
                        }
                    
                    Text("Tap anywhere to dismiss!")
                } //: ZSTACK
                .transition(.reverseRipple(location: overlayRippleLocation))
            }
        }
    }
    
    
    // MARK: Views
    
    /// Image View
    @ViewBuilder
    private func imageView(_ index: Int, size: CGSize) -> some View {
        Image("Pic \(index + 1)")
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipShape(.rect(cornerRadius: 30))
    }
    
}

#Preview {
    ContentView()
}
