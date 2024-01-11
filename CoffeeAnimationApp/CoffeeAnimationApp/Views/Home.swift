//
//  Home.swift
//  CoffeeAnimationApp
//
//  Created by Matteo Buompastore on 11/01/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - UI
    @State private var offsetY: CGFloat = .zero
    @State private var currentIndex: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            /// Since the card size will take the entire screen
            let cardSize = size.width * 1
            
            /// Bottom Gradient background
            LinearGradient(colors: [.clear, .brown.opacity(0.2), .brown.opacity(0.45), .brown],
                           startPoint: .top,
                           endPoint: .bottom)
            .frame(height: 300)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            
            /// Header View
            HeaderView()
            
            VStack(spacing: 0) {
                ForEach(coffees) { coffee in
                    CoffeeView(coffee: coffee, size: size)
                } //: COFFEE LOOP
            } //: VSTACK
            .frame(width: size.width)
            .padding(.top, size.height - cardSize)
            .offset(y: offsetY)
            .offset(y: -currentIndex * (cardSize))
            
        } // GEOMETRY
        .coordinateSpace(name: "SCROLL")
        .contentShape(.rect)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    /// Slowing down the gesture
                    offsetY = value.translation.height * 0.4
                }).onEnded({ value in
                    let translationY = value.translation.height
                    withAnimation(.easeInOut) {
                        if translationY > 0 {
                            // 250 -> Update it as you need
                            if currentIndex > 0 && translationY > 250 {
                                currentIndex -= 1
                            }
                        } else {
                            if currentIndex < CGFloat(coffees.count - 1) && -translationY > 250 {
                                currentIndex += 1
                            }
                        }
                        
                        
                        offsetY = .zero
                    }
                })
        )
        .preferredColorScheme(.light)
    }
    
    //MARK: - Views
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            
            HStack {
                
                Button(action: {}, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundStyle(.black)
                })
                
                Spacer()
                
                Button(action: {}, label: {
                    Image(systemName: "cart.fill")
                        .font(.title2.bold())
                        .foregroundStyle(.black)
                })
                
            } //: HSTACK
            
            /// Animated Slider
            GeometryReader {
                let size = $0.size
                
                HStack(spacing: 0) {
                    ForEach(coffees) {coffee in
                        VStack(spacing: 15) {
                            Text(coffee.title)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                            
                            Text(coffee.price)
                                .font(.title)
                        } //: VSTACK
                        .frame(width: size.width)
                    } //: LOOP
                } //: HSTACK
                .offset(x: currentIndex * -size.width)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8), value: currentIndex)
            } //: GEOMETRY
            .padding(.top, -5)
            
        } //: VSTACK
        .padding(15)
    }
    
}

struct CoffeeView: View {
    
    var coffee: Coffee
    var size: CGSize
    
    var body: some View {
        let cardSize = size.width * 1
        /// Max 4 cards on the screen at a time
        let maxCardsDisplaySize = size.width * 4
        GeometryReader { proxy in
            let _size = proxy.size
            // Scaling
            let offset = proxy.frame(in: .named("SCROLL")).minY - (size.height - cardSize)
            let scale = offset <= 0 ? (offset / maxCardsDisplaySize) : 0
            let reducedScale = 1 + scale
            let currentCardScale = offset / cardSize
            
            Image(coffee.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: _size.width, height: _size.height)
            /// To avoid warning update anchor based on current card scale
                .scaleEffect(reducedScale < 0 ? 0.001 : reducedScale,
                             anchor: .init(x: 0.5, y: 1 - currentCardScale / 2.4))
            /// When it's coming from the bottom the animation scales from large to actual
                .scaleEffect(offset > 0 ? 1 + currentCardScale : 1, anchor: .top)
            /// To remove the excess next view using offset to move the view in real time
                .offset(y: offset > 0 ? currentCardScale * 200 : 0)
                .offset(y: currentCardScale * -130)
            
        } //: GEOMETRY
        .frame(height: cardSize)
    }
    
}

#Preview {
    Home()
}
