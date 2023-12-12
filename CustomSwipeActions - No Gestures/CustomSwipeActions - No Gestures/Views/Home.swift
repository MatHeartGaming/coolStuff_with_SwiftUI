//
//  Home.swift
//  CustomSwipeActions - No Gestures
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI

struct Home: View {
    
    /// Sample Array of colors
    @State private var colors: [Color] = [.black, .yellow, .purple, .brown]
    
    var body: some View {
        ScrollView(.vertical) {
            
            LazyVStack(spacing: 10) {
                
                ForEach(colors, id: \.self) { color in
                    
                    SwipeAction(cornerRadius: 15, direction: .trailing) {
                        CardView(color)
                    } actions: {
                        Action(tint: .blue, icon: "star.fill", isEnabled: color == .black) {
                            print("Bookmarked")
                        }
                        
                        Action(tint: .red, icon: "trash.fill") {
                            print("Delete")
                            withAnimation(.snappy) {
                                colors.removeAll(where: { $0 == color })
                            }
                        }
                    }

                    
                } //: LOOP
                
            } //: Lazy VSTACK
            .padding(15)
            
        } //: SCROLLVIEW
        .scrollIndicators(.hidden)
    }
    
    
    //MARK: - Other Views
    
    @ViewBuilder
    func CardView(_ color: Color) -> some View {
        HStack(spacing: 12) {
            
            Circle()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 6) {
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 80, height: 5)
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 60, height: 5)
                
            } //: VSTACK
            
            Spacer(minLength: 0)
            
        } //: HSTACK
        .foregroundStyle(.white.opacity(0.4))
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(color.gradient)
    }
    
}

#Preview {
    Home()
}
