//
//  ContentView.swift
//  Interactive Floating Action Button
//
//  Created by Matteo Buompastore on 04/04/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var colors: [Color] = [.red, .blue, .green, .cyan, .brown, .purple, .indigo, .mint, .pink]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(color.gradient)
                            .frame(height: 200)
                    } //: Loop Colors
                } //: Lazy VStack
                .padding(15)
            } //: V-SCROLL
            .navigationTitle("Floating Button")
        } //: NAVIGATION
        .overlay(alignment: .bottomTrailing) {
            FloatingButton {
                FloatingAction(symbol: "tray.full.fill") {
                    
                }
                FloatingAction(symbol: "lasso.badge.sparkles") {
                    
                }
                FloatingAction(symbol: "square.and.arrow.up.fill") {
                    
                }
            } label: { isExpanded in
                Image(systemName: "plus")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                    .scaleEffect(1.02)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black, in: .circle)
                    .scaleEffect(isExpanded ? 0.9 : 1)
            }
            .padding()

        }
    }
}

#Preview {
    ContentView()
}
