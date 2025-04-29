//
//  ContentView.swift
//  SkeletonLoadingView
//
//  Created by Matteo Buompastore on 29/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isLoading: Bool = true
    @State private var card: Card?
    
    var body: some View {
        VStack {
            SomeCardView(card: card)
                .onTapGesture {
                    withAnimation(.smooth) {
                        if card == nil {
                            card = .init(
                                image: "",
                                title: "World Wide Developer Conference 2025",
                                subtitle: "From June 9th 2025",
                                description: "Be there to see the future of technology!"
                            )
                        } else {
                            card = nil
                        }
                    }
                }
            Spacer()
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

struct SomeCardView: View {
    
    var card: Card?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    if let card {
                        Image(card.image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        SkeletonView(.rect)
                    }
                }
                .frame(height: 220)
                .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                
                if let card {
                    Text(card.title)
                        .fontWeight(.semibold)
                } else {
                    SkeletonView(.rect(cornerRadius: 5))
                        .frame(height: 20)
                }
                
                Group {
                    if let card {
                        Text(card.subtitle)
                            .font(.callout)
                    } else {
                        SkeletonView(.rect(cornerRadius: 5))
                            .frame(height: 15)
                    }
                }
                .padding(.trailing, 30)
                
                ZStack {
                    if let card {
                        Text(card.subtitle)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    } else {
                        SkeletonView(.rect(cornerRadius: 5))
                    }
                }
                .frame(height: 50)
                .lineLimit(3)
            } //: VSTACK
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
