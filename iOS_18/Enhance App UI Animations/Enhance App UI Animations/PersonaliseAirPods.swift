//
//  PersonaliseAirPods.swift
//  Enhance App UI Animations
//
//  Created by Matteo Buompastore on 18/09/24.
//

import SwiftUI

struct PersonaliseAirPods: View {
    
    @State private var showView: Bool = false
    
    var body: some View {
        ZStack {
            if showView {
                ExpandedView()
                    .transition(.blurReplace(.downUp).combined(with: .push(from: .bottom)))
            } else {
                MinimisedView()
                    .transition(.blurReplace(.downUp).combined(with: .push(from: .bottom)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.fill)
    }
    
    
    @ViewBuilder
    private func ExpandedView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Engraving")
                .font(.callout)
                .fontWeight(.semibold)
            
            Text("Add a message that lasts.")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Choose from engraving options. It's the perfect way to personalise your AirPods. Add a special message, name or birthday. Even combine text and numbers with your favourite emoji!")
                .font(.callout)
            
            Link("Learn more", destination: URL(string: "https://apple.com")!)
            
        } //: VSTACK
        .frame(width: 250)
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation((.bouncy)) {
                    showView.toggle()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.primary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
        }
    }
    
    @ViewBuilder
    private func MinimisedView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Image(systemName: "face.smiling")
                .font(.title)
            
            Text("Personalise your AirPods for free.")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Engrave your new AirPods with a mix of emojis, names, initials and numbers.")
                .font(.callout)
            
            Button {
                withAnimation((.bouncy)) {
                    showView.toggle()
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.primary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        } //: VSTACK
        .frame(width: 250)
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
        }
    }
    
}

#Preview {
    PersonaliseAirPods()
}
