//
//  Home.swift
//  Stacked Scroll View
//
//  Created by Matteo Buompastore on 20/05/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            StackedCards(items: items, stackedDisplayCount: 2, opacityDisplayCount: 2, itemHeight: 70) { item in
                CardView(item)
            } //: Stacked Cards
            .padding(.bottom, 20)
            
            BottomActionBar()
            
        } //: VSTACK
        .padding(20)
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func CardView(_ item: Item) -> some View {
        if item.logo.isEmpty {
            Rectangle()
                .fill(.clear)
        } else {
            HStack(spacing: 12) {
                Image(item.logo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(.circle)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.callout)
                        .fontWeight(.bold)
                    
                    Text(item.description)
                        .font(.caption)
                        .lineLimit(1)
                } //: VSTACK
                .foregroundStyle(.white.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)
            } //: HSTACK
            .padding(10)
            .frame(maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 20))
        }
        
    }
    
    @ViewBuilder
    private func BottomActionBar() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "flashlight.off.fill")
                    .font(.title3)
                    .frame(width: 35, height: 35)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.2))
            .buttonBorderShape(.circle)
            
            Spacer(minLength: 0)

            Button {
                
            } label: {
                Image(systemName: "camera.fill")
                    .font(.title3)
                    .frame(width: 35, height: 35)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.2))
            .buttonBorderShape(.circle)
            
        } //: HSTACK
    }
    
}

#Preview {
    ContentView()
}
