//
//  Home.swift
//  Animated Page Indicator Old
//
//  Created by Matteo Buompastore on 01/03/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - Properties
    var colors: [Color] = [.red, .blue, .pink, .purple]
    
    /// Offset
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let safeArea = proxy.safeAreaInsets
            /// Had to use ScrollView because with new versions of SwiftUI the TabView removes the previous view when in paginated mode thus loosing the offset.
            ScrollView(.horizontal) {
                HStack {
                    ForEach(colors.indices, id: \.self) { index in
                        Group {
                            if index == 0 {
                                colors[index]
                                    .overlay(alignment: .leading) {
                                        GeometryReader { proxy2 -> Color in
                                            let minX = proxy2.frame(in: .global).minX
                                            
                                            print(minX)
                                            
                                            DispatchQueue.main.async {
                                                withAnimation {
                                                    self.offset = -minX
                                                }
                                            }
                                            
                                            return Color.clear
                                        }
                                        .frame(width: 0, height: 0)
                                    }
                            } else {
                                colors[index]
                            }
                        }
                        .frame(width: size.width)
                        .ignoresSafeArea()
                        
                    } //: Loop Colors
                } //: HSTACK
            } //: SCROLL
            //.tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                /// Indicators
                HStack(spacing: 15) {
                    ForEach(colors.indices, id: \.self) { index in
                        Capsule()
                            .fill(.white)
                            .frame(width: getIndex(size: size) == index ? 20 : 7, height: 7)
                    }
                } //: HSTACK
                .overlay {
                    Capsule()
                        .fill(.white)
                        .frame(width: 20, height: 7)
                        .offset(x: getOffset(width: size.width) - 30)
                }
                .padding(.bottom, safeArea.bottom)
            }
        }
    }
    
    
    // MARK: - Functions
    
    private func getIndex(size: CGSize) -> Int {
        let index = Int(round(Double(offset / size.width)))
        //print("Index: \(index)")
        return index
        
    }
    
    private func getOffset(width: CGFloat) -> CGFloat {
        /// spacing = 15, Circle width = 7. Total = 22
        let progress = offset / width
        return 22 * progress
    }
    
}

#Preview {
    Home()
}
