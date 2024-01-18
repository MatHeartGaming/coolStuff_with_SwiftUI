//
//  CustomTabBar.swift
//  Playstation App Bar
//
//  Created by Matteo Buompastore on 18/01/24.
//

import SwiftUI

struct CustomTabBar: View {
    
    //MARK: - PROPERTIES
    @Binding var activeTab: Tab
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Image(tab.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .offset(y: offset(for: tab))
                        .contentShape(.rect)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                activeTab = tab
                            }
                        }
                        .frame(maxWidth: .infinity)
                } //: LOOP ICONS
            } //: HSTACK
            .padding(.top, 12)
            .padding(.bottom, 20)
        } //: VSTACK
        .padding(.bottom, safeArea.bottom == 0 ? 30 : safeArea.bottom)
        .background {
            ZStack {
                /// Adding Border
                /// TabBarTopCurve()
                TabBarTopCurve()
                    .stroke(.white, lineWidth: 0.5)
                    .blur(radius: 0.5)
                    .padding(.horizontal, -10)
                
                TabBarTopCurve()
                    .fill(.BG.opacity(0.5).gradient)
                    
            }
        }
        .overlay {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .global)
                let width = rect.width
                let maxedWidth = width * 5
                let height = rect.height
                
                Circle()
                    .fill(.clear)
                    .frame(width: maxedWidth, height: maxedWidth)
                    .background(alignment: .top) {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                .tabBG, .BG, .BG
                            ], startPoint: .top, endPoint: .bottom))
                            .frame(width: width, height: height)
                        /// Masking it into its native circle
                            .mask(alignment: .top) {
                                Circle()
                                    .frame(width: maxedWidth, height: maxedWidth, alignment: .top)
                            }
                    }
                    /// Border
                    .overlay {
                        Circle()
                            .stroke(.white, lineWidth: 0.2)
                            .blur(radius: 0.5)
                    }
                    .frame(width: width)
                    /// Indicator
                    .background {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 45, height: 4)
                            /// Glow
                            .glow(.white.opacity(0.5), radius: 50)
                            .glow(Color("Blue").opacity(0.7), radius: 30)
                            /// At the center moving to the top
                            .offset(y: -1.5)
                            .offset(y: -maxedWidth / 2)
                            .rotationEffect(.degrees(calculateRotation(maxedWidth: maxedWidth / 2, 
                                                                       actualWidth: width,
                                                                       isInital: true)))
                            .rotationEffect(.degrees(calculateRotation(maxedWidth: maxedWidth / 2,
                                                                       actualWidth: width)))
                    } //: CIRCLE BACKGROUND
                    .offset(y: height / 2.1)
            } //: GEOMETRY
            /// Active tab text
            .overlay(alignment: .bottom) {
                Text(activeTab.rawValue)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .offset(y: safeArea.bottom == 0 ? -15 : -safeArea.bottom + 12)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    
    //MARK: - Functions
    
    func calculateRotation(maxedWidth y: CGFloat, actualWidth: CGFloat, isInital: Bool = false) -> CGFloat {
        let tabWidth = actualWidth / Tab.count
        //// This is actually X
        let firstTabPositionX: CGFloat = -(actualWidth - tabWidth) / 2
        let tan = y / firstTabPositionX
        let radians = atan(tan)
        let degree = radians * 180 / .pi
        
        if isInital {
            return -(degree + 90)
        }
        let x = tabWidth * activeTab.index
        let tan_ = y / x
        let radians_ = atan(tan_)
        let degree_ = radians_ * 180 / .pi
        return -(degree_ - 90)
    }
    
    func offset(for tab: Tab) -> CGFloat {
        let totalIndices = Tab.count
        let currentIndex = tab.index
        let progress = currentIndex / totalIndices
        return progress < 0.5 ? (currentIndex * -10) : ((totalIndices - currentIndex - 1) * -10)
    }
    
}


/// Tab Bar Custom Shape
struct TabBarTopCurve: Shape {
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let width = rect.width
            let height = rect.height
            let midWidth = rect.width / 2
            path.move(to: .init(x: 0, y: 5))
            
            /// Addiing curves
            path.addCurve(to: .init(x: midWidth, y: -20), control1: .init(x: midWidth / 2, y: -20), control2: .init(x: midWidth, y: -20))
            path.addCurve(to: .init(x: width, y: 5), control1: .init(x: (midWidth + (midWidth / 2)), y: -20), control2: .init(x: width, y: 5))
            
            /// Completing Rectangle (Shade below the upper curve)
            path.addLine(to: .init(x: width, y: height))
            path.addLine(to: .init(x: 0, y: height))
            
            /// Closing path
            path.closeSubpath()
        }
    }
    
}

#Preview {
    CustomTabBar(activeTab: .constant(.play))
}

#Preview {
    ContentView()
}
