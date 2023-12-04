//
//  Home.swift
//  ParticleEffect
//
//  Created by Matteo Buompastore on 04/12/23.
//

import SwiftUI

struct Home: View {
    
    //MARK: - UI
    @State private var isLinked = [false, false, false]
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                CustomButton(systemImage: "suit.heart.fill", status: isLinked[0], activeTint: .pink, inactiveTint: .gray) {
                    isLinked[0].toggle()
                }
                
                CustomButton(systemImage: "star.fill", status: isLinked[1], activeTint: .yellow, inactiveTint: .gray) {
                    isLinked[1].toggle()
                }
                
                CustomButton(systemImage: "square.and.arrow.up.fill", status: isLinked[2], activeTint: .blue, inactiveTint: .gray) {
                    isLinked[2].toggle()
                }
            } //: HSTACK
        } //: VSTACK
    }
    
    @ViewBuilder
    func CustomButton(systemImage: String, status: Bool, activeTint: Color, inactiveTint: Color, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.title2)
                .particleEffect(systemImage: systemImage,
                                font: .title2,
                                status: status,
                                activeTint: activeTint,
                                inactiveTint: inactiveTint
                )
                .foregroundStyle(status ? activeTint : inactiveTint)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(status ? activeTint.opacity(0.25) : Color("ButtonColor"))
                }
        }
    }
    
}

#Preview {
    Home()
}
