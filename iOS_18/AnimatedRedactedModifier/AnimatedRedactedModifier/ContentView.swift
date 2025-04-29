//
//  ContentView.swift
//  AnimatedRedactedModifier
//
//  Created by Matteo Buompastore on 29/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var card: Card?
    
    var body: some View {
        VStack {
            if let card {
                CardView(card: card)
            } else {
                CardView(card: Card(
                    image: "",
                    title: "",
                    subtitle: "",
                    description: ""
                ))
                .skeleton(isRedacted: true)
            }
            
            Spacer(minLength: 0)
        }
        .onTapGesture {
            withAnimation(.smooth) {
                card = Card(
                    image: "",
                    title: "World Wide Developer Conference 2025",
                    subtitle: "From June 9th 2025",
                    description: "Be there to see the future of technology!"
                )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}

struct Card: Identifiable {
    let id: String = UUID().uuidString
    var image: String
    var title: String
    var subtitle: String
    var description: String
}

struct CardView: View {
    
    var card: Card
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    Image(card.image)
                        .resizable()
                        .scaledToFill()
                }
                .frame(height: 220)
                .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(card.title)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(card.subtitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .padding(.trailing, 30)
                
                
                Text(card.description)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }  //: VSTACK
            .padding([.horizontal, .top], 25)
            .padding(.bottom, 25)
        } //: VSTACK
        .background(.background)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(color: .black.opacity(0.1), radius: 10)
        
    }
}

#Preview {
    ContentView()
}
