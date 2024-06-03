//
//  Home.swift
//  Vertical Circular Carousel
//
//  Created by Matteo Buompastore on 03/06/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(cards) { card in
                        CardView(card)
                            .frame(width: 220, height: 150)
                            .visualEffect { content, geometryProxy in
                                content
                                    .offset(x: -150)
                                    .rotationEffect(.degrees(cardRotation(geometryProxy)), anchor: .trailing)
                                    .offset(x: 100, y: -geometryProxy.frame(in: .scrollView(axis: .vertical)).minY)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } //: Lazy V-STACK
                .scrollTargetLayout()
            } //: V-SCROLL
            .safeAreaPadding(.vertical, (size.height * 0.5) - 75)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .background {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: size.height, height: size.height)
                    .offset(x: size.height / 2)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Button(action: {}, label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                        .foregroundStyle(Color.primary)
                })
                
                Text("Total")
                    .font(.title3.bold())
                    .padding(.top, 10)
                
                Text("€972.45")
                    .font(.largeTitle)
                
                Text("Choose a Card")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            } //: VSTACK
            .padding(15)
            
        } //: GEOMETRY
        .toolbar(.hidden, for: .navigationBar)
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func CardView(_ card: Card) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(card.color.gradient)
            
            /// Details
            VStack(alignment: .leading, spacing: 10) {
                Image(.visa)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: 40)
                
                Spacer(minLength: 0)
                
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { _ in
                        Text("****")
                        Spacer(minLength: 0)
                    } //: Loop
                    
                    Text(card.number)
                        .offset(y: -2)
                    
                } //: HSTACK
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.bottom, 10)
                
                HStack {
                    Text(card.name)
                    
                    Spacer(minLength: 0)
                    
                    Text(card.date)
                } //: HSTACK
                .font(.caption.bold())
                .foregroundStyle(.white)
                
            } //: VSTACK
            .padding(25)
            
        } //: ZSTACK
    }
    
    
    //MARK: - Functions
    
    private func cardRotation(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let height = proxy.size.height
        let progress = minY / height
        let angleForEachCard: CGFloat = -50
        let cappedProgress = progress < 0 ? min(max(progress, -3), 0) : max(min(progress, 3), 0)
        return cappedProgress * angleForEachCard
    }
    
}

#Preview {
    Home()
}
