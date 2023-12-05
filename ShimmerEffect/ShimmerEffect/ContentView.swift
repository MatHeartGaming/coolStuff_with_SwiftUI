//
//  ContentView.swift
//  ShimmerEffect
//
//  Created by Matteo Buompastore on 05/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Hello Shimmer")
                    .font(.title)
                    .fontWeight(.black)
                    /// Shimmer
                    .shimmer(.init(tint: .white.opacity(0.5), highlight: .white, blur: 5))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.red.gradient)
                    )
            
                HStack(spacing: 15) {
                    ForEach(["suit.heart.fill", "box.truck.badge.clock.fill",
                             "person.crop.circle.badge.checkmark"], id: \.self) { icon in
                        
                        Image(systemName: icon)
                            .font(.title)
                            .shimmer(.init(tint: .white.opacity(0.3), highlight: .white, blur: 3, speed: 2))
                            .frame(width: 40, height: 40)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(.indigo)
                            )
                        
                    } //: LOOP
                } //: HSTACK
                
                HStack {
                    Circle()
                        .frame(width: 55, height: 55)
                    
                    VStack {
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: 10)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: 10)
                            .padding(.trailing, 50)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: 10)
                            .padding(.trailing, 100)
                        
                    }
                    
                }
                .padding()
                .padding(.horizontal)
                .shimmer(.init(tint: .red.opacity(0.8), highlight: .white, blur: 25))
            
            } //: VSTACK
            .navigationTitle("Shimmer Effect")
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
