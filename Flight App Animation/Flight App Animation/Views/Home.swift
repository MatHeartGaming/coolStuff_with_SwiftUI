//
//  Home.swift
//  Flight App Animation
//
//  Created by Matteo Buompastore on 15/02/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - Properties
    let size: CGSize
    let safeArea: EdgeInsets
    
    /// Gesture
    @State private var offsetY: CGFloat = 0
    @State private var currentCardIndex: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .overlay(alignment: .bottomTrailing) {
                    Button(action: {}, label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .frame(width: 40, height: 40)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.35), radius: 5, x: 5, y: 5)
                            }
                    })
                    .offset(x: -15, y: 15)
                }
                .zIndex(1)
            PaymentCardView()
                .zIndex(0)
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.BG
                .ignoresSafeArea()
        }
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            Image(.logo)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.white)
                .scaledToFit()
                .frame(width: size.width * 0.4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                FlightDetailsView(place: "Napoli", code: "NAC", timing: "24 Jul, 11:00")
                
                VStack(spacing: 8) {
                    
                    Image(systemName: "chevron.right")
                        .font(.title2)
                    
                    Text("2h 25m")
                    
                } //: VSTACK
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                
                FlightDetailsView(alignment: .trailing, place: "Dublin", code: "DUB", timing: "24 Jul, 13:25")
            } //: HSTACK
            .padding(.bottom, -15)
            
            /// Airplane Image
            Image(.airplane)
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .padding(.bottom, -20)
            
        } //: VSTACK
        .padding([.horizontal, .top], 15)
        .background {
            Rectangle()
                .fill(.linearGradient(colors: [
                    .blueTop,
                    .blueTop,
                    .blueBottom
                ],
                                      startPoint: .top,
                                      endPoint: .bottom))
        } //: Background
    }
    
    @ViewBuilder
    private func PaymentCardView() -> some View {
        VStack {
            Text("SELECT PAYMENT METHOD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.vertical)
            
            GeometryReader { _ in
                VStack(spacing: 0) {
                    ForEach(sampleCards.indices, id: \.self) { index in
                        CardView(index: index)
                    } //: Loop Cards
                } //: VSTACK
                .padding(.horizontal, 30)
                .offset(y: offsetY)
                .offset(y: currentCardIndex * -200)
                
                /// Gradient View
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .white.opacity(0.3),
                        .white.opacity(0.7),
                        .white
                    ], startPoint: .top, endPoint: .bottom))
                    /// Since the Rectangle is on top of the Cards it will prevent tapping, so we disable hit testing on it.
                    .allowsHitTesting(false)
                
                /// Purchase Button
                Button(action: {}, label: {
                    Text("Confirm €320.00")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(.blueTop.gradient)
                        }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, safeArea.bottom == 0 ? 15 : safeArea.bottom)
                
                
            } //: GEOMETRY
            .coordinateSpace(name: "SCROLL")
        } //: VSTACK
        .contentShape(.rect)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    /// Decreasing speed
                    offsetY = value.translation.height * 0.3
                })
                .onEnded({ value in
                    let translation = value.translation.height
                    withAnimation(.easeInOut) {
                        /// Increasing / Decreasing index on condition
                        if translation > 100 && currentCardIndex > 0 {
                            currentCardIndex -= 1
                        } else if translation < 0 && -translation > 100 && currentCardIndex < CGFloat(sampleCards.count - 2) {
                            currentCardIndex += 1
                        }
                        
                        offsetY = .zero
                    }
                })
        )
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func CardView(index: Int) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / size.height
            let contrainedProgress = progress > 1 ? 1 : (progress < 0) ? 0 : progress
            
            Image(sampleCards[index].cardImage)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                /// Shadow
                .shadow(color: .black.opacity(0.14), radius: 8, x: 6, y: 6)
                /// Stacked Animation
            .rotation3DEffect(
                .degrees(contrainedProgress * 40.0),
                axis: (x: 1, y: 0, z: 0.0), anchor: .bottom)
                .padding(.top, progress * -160)
                /// Moving current Card to the Top
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
        .onTapGesture {
            print(index)
        }
    }
    
}

#Preview {
    GeometryReader {
        let size = $0.size
        let safeArea = $0.safeAreaInsets
        Home(size: size, safeArea: safeArea)
            .ignoresSafeArea(.container, edges: .vertical)
    }
}
