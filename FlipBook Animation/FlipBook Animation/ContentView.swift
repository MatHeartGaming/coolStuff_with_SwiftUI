//
//  ContentView.swift
//  FlipBook Animation
//
//  Created by Matteo Buompastore on 19/04/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State private var progress: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                OpenableBookView(config: .init(progress: progress)) { size in
                    FrontView(size)
                } insideLeft: { size in
                    LeftView(size)
                } insideRight: { size in
                    RightView(size)
                }
                
                HStack(spacing: 12) {
                    Slider(value: $progress)
                        
                    Button("Open") {
                        withAnimation(.snappy(duration: 1)) {
                            progress = (progress == 1 ? 0.2 : 1)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                } //: HSTACK
                .padding(10)
                .background(.background, in: .rect(cornerRadius: 10))
                .padding(.top, 50)

            } //: VSTACK
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.15))
            .navigationTitle("Book View")
        } //: NAVIGATION
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func FrontView(_ size: CGSize) -> some View {
        Image(.book1)
            .resizable()
            .scaledToFill()
            //.offset(y: 10)
            .frame(width: size.width, height: size.height)
    }
    
    @ViewBuilder
    private func LeftView(_ size: CGSize) -> some View {
        VStack(spacing: 5) {
            Image(.author1)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(.circle)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
            
            Text("J.K. Rowling")
                .fontWidth(.condensed)
                .fontWeight(.bold)
                .padding(.top, 8)
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
    
    @ViewBuilder
    private func RightView(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.system(size: 14))
            
            Text("J.K Rownling is famous worldwide for the renowned series Harry Potter...")
                .font(.caption)
                .foregroundStyle(.gray)
        } //: VSTACK
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}


/// Animatable makes the progress increase / decrease progressively instead to change immediately!!
struct OpenableBookView<Front: View, InsideLeft: View, InsideRight: View>: View, Animatable {
    
    var config: Config = .init()
    
    //MARK: - Properties
    @ViewBuilder var front: (CGSize) -> Front
    @ViewBuilder var insideLeft: (CGSize) -> InsideLeft
    @ViewBuilder var insideRight: (CGSize) -> InsideRight
    
    var animatableData: CGFloat {
        get { return config.progress}
        set { config.progress = newValue }
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            /// Limiting progress between 1-0
            let progress = max(min(config.progress, 1), 0)
            let rotation = progress * -180
            let cornerRadius = config.cornerRadius
            let shadowColor = config.shadowColor
            
            ZStack {
                
                insideRight(size)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: cornerRadius,
                            topTrailingRadius: cornerRadius)
                    )
                    .shadow(color: shadowColor.opacity(0.1 * progress), radius: 5, x: 5, y: 0)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(config.dividerBackground.shadow(
                                .inner(color: shadowColor.opacity(0.15), 
                                       radius: 2)))
                            .frame(width: 6)
                            .offset(x: -3)
                            .clipped()
                    }
                
                
                front(size)
                    .frame(width: size.width, height: size.height)
                    /// Disabling Interactions once the book cover (front view) is flipped
                    .allowsHitTesting(-rotation > 90)
                    .overlay {
                        if -rotation > 90 {
                            insideLeft(size)
                                .frame(width: size.width, height: size.height)
                                .scaleEffect(x: -1)
                                .transition(.identity)
                        }
                    }
                    .clipShape(.rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: config.cornerRadius,
                            topTrailingRadius: config.cornerRadius)
                    )
                    .shadow(color: shadowColor.opacity(0.1), radius: 5, x: 5, y: 0)
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0.0, y: 1.0, z: 0.0),
                                      anchor: .leading,
                                      perspective: 0.3
                    )
                
                
                
            } //: ZSTACK
            .offset(x: (config.width / 2) * progress)
        } //: GEOMETRY
        .frame(width: config.width, height: config.height)
    }
    
    struct Config {
        var width: CGFloat = 150
        var height: CGFloat = 200
        var progress: CGFloat = 0
        var cornerRadius: CGFloat = 10
        var shadowColor: Color = .black
        var dividerBackground: Color = .white
    }
    
}

#Preview {
    ContentView()
}
