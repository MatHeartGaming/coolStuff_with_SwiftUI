//
//  Speedometer.swift
//  ExpenseTracker Animation Challenge
//
//  Created by Matteo Buompastore on 29/01/24.
//

import SwiftUI

struct Speedometer: View {
    
    //MARK: - Properties
    @Binding var progress: CGFloat
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                /// Iterate Capsule Shape to 180°
                ForEach(1...60, id: \.self) { index in
                    /// 60 * 3 = 180
                    let deg = CGFloat(index) * 3
                    
                    Capsule()
                        .fill(.gray.opacity(0.25))
                        .frame(width: 40, height: 4)
                        .offset(x: -(size.width - 40) / 2)
                        .rotationEffect(.degrees(deg))
                }
            } //: ZSTACK
            .frame(width: size.width, height: size.height, alignment: .bottom)
            
            
            ZStack {
                /// Iterate Capsule Shape to 180°
                ForEach(1...60, id: \.self) { index in
                    let deg = CGFloat(index) * 3
                    
                    Capsule()
                        /// To change Speedometer ticks color as the degree increases
                        .fill(deg < 60 ? .ring1 : (deg >= 60 && deg < 120 ? .ring2 : .ring3))
                        .frame(width: 40, height: 4)
                        .offset(x: -(size.width - 40) / 2)
                        .rotationEffect(.degrees(deg))
                }
            } //: ZSTACK
            .frame(width: size.width, height: size.height, alignment: .bottom)
            /// Masking update with progress animation
            .mask {
                Circle()
                    .trim(from: 0, to: (progress / 2) + 0.002)
                    .stroke(.white, lineWidth: 40)
                    .frame(width: size.width + 150, height: size.height + 150)
                    .offset(y: -(size.height) / 2)
                    .rotationEffect(.degrees(180))
                    //.rotation3DEffect(.degrees(1), axis: (x: 0.0, y: 0.0, z: 1.0))
            }
            
        } //: GEOMETRY
        .overlay(alignment: .bottom) {
            HStack {
                Text("0%")
                    .font(.system(size: 15, weight: .semibold))
                    .offset(x: 10)
                
                Spacer()
                
                AnimatedText(value: progress * 100,
                             font: .system(size: 15, weight: .semibold),
                             additionalString: "%"
                )
                //Text("\(Int(progress * 100))%")
                   
            } //: HSTACK
            .offset(y: 25)
        } //: Overlay percentage
        .overlay {
            /// Custom Indicator
            IndicatorShape()
                .fill(.indicator)
                .overlay(alignment: .bottom) {
                    Circle()
                        .fill(.indicator)
                        .frame(width: 30, height: 30)
                        .overlay {
                            Circle()
                                .fill(.BG)
                                .padding(6)
                        }
                        .offset(y: 10)
                } //: Overlay Indicator Bottom Dot
                .frame(width: 25)
                .padding(.top, 40)
                .rotationEffect(.degrees(-90), anchor: .bottom)
                .rotationEffect(.degrees(progress * 180), anchor: .bottom)
                .offset(y: -5)
        } //: Overlay Indicator
        .padding(.top)
        .padding(10)
    }
}

#Preview {
    Home()
        .preferredColorScheme(.dark)
}

#Preview {
    Speedometer(progress: .constant(0.5))
        .preferredColorScheme(.dark)
}
