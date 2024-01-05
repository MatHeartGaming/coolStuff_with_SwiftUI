//
//  Home.swift
//  MaterialCarouselSlider
//
//  Created by Matteo Buompastore on 05/01/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - PROPERTIES
    @State private var cards: [Card] = [
        .init(image: "pic1"),
        .init(image: "pic2"),
        .init(image: "pic3"),
        .init(image: "pic4"),
        .init(image: "pic5"),
        .init(image: "pic6"),
        .init(image: "pic7"),
        .init(image: "pic8")
    ]
    
    var body: some View {
        
        VStack {
            GeometryReader {
                let size = $0.size
                
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(cards) { card in
                            CardView(card)
                        } //: LOOP PICS
                    } //: HSTACK
                    .padding(.trailing, size.width - 180)
                    .scrollTargetLayout()
                    
                } //: SCROLL
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
                .clipShape(.rect(cornerRadius: 25))
            } //: GEOMETRY
            .padding(.horizontal, 15)
            .padding(.top, 30)
            .frame(height: 210)
            
            Spacer(minLength: 0)
        } //: VSTACK
        
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    func CardView(_ card: Card, cardWidth: CGFloat = 130) -> some View {
        GeometryReader {
            let size = $0.size
            let minX = $0.frame(in: .scrollView).minX
            /// 190: 180 - Card Width; 10 - spacing
            let reducingWidth = (minX / 190) * cardWidth
            let cappedWidth = min(reducingWidth, cardWidth)
            
            let frameWidth = size.width - (minX > 0 ? cappedWidth : -cappedWidth)
            
            Image(card.image)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .frame(width: frameWidth < 0 ? 0 : frameWidth)
                .clipShape(.rect(cornerRadius: 25))
                .offset(x: minX > 0 ? 0 : -cappedWidth)
                .offset(x: -card.previousOffset)
        }
        .frame(width: 180, height: 200)
        .offsetX { offset in
            let reducingWidth = (offset / 190) * cardWidth
            let index = cards.indexOf(card)
            if cards.indices.contains(index + 1) {
                cards[index + 1].previousOffset = (offset < 0 ? 0 : reducingWidth)
            }
        }
    }
    
}

#Preview(traits: .portrait) {
    Home()
}
