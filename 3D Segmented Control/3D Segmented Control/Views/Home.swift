//
//  Home.swift
//  3D Segmented Control
//
//  Created by Matteo Buompastore on 18/01/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - PROPERTIES
    @State private var currentTab: Tab = .photo
    
    /// Shaking the segmented control on tap
    @State private var shakeValue: CGFloat = 0
    
    init() {
        /// In Case modifier does not work
        // UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack {
            
            SegmentedControl()
                .padding(15)
            
            TabView(selection: $currentTab) {
                SampleGridView()
                    .toolbar(.hidden, for: .tabBar) // iOS 16+
                    .tag(Tab.photo)
                
                SampleGridView(true)
                    .toolbar(.hidden, for: .tabBar) // iOS 16+
                    .tag(Tab.video)
            } //: TABVIEW
            
        } //: VSTACK
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    func SegmentedControl() -> some View {
        HStack(spacing: 0) {
            TappableText(.photo)
                .overlay {
                    /// Current tab higlight with 3D animation
                    CustomCorner(corners: [.topLeft, .bottomLeft], radius: 50)
                        .fill(Color("Pink"))
                        .overlay {
                            TappableText(.video)
                                .foregroundStyle(currentTab == .video ? .white : .clear)
                                .scaleEffect(x: -1)
                        }
                        .overlay {
                            TappableText(.photo)
                                .foregroundStyle(currentTab == .video ? .clear : .white)
                        }
                    /// Flipping horizontally
                        .rotation3DEffect(
                            .degrees(currentTab == .photo ? 0 : 180),axis: (x: 0.0, y: 1.0, z: 0.0), 
                            anchor: .trailing, perspective: 0.45)
                }
            /// Put the view above the next view
                .zIndex(1)
                .contentShape(.rect)
            
            TappableText(.video)
                .foregroundStyle(Color("Pink"))
        } //: HSTACK
        .background {
            ZStack {
                Capsule()
                    .fill(.white)
                
                Capsule()
                    .stroke(Color("Pink"), lineWidth: 3)
            }
        }
        .rotation3DEffect(.degrees(shakeValue), axis: (x: 0, y: 1, z: 0))
    }
    
    @ViewBuilder
    func TappableText(_ tab: Tab) -> some View {
        Text(tab.rawValue)
            .font(.title3)
            .fontWeight(.semibold)
            .contentTransition(.interpolate)
            .padding(.vertical, 12)
            .padding(.horizontal, 40)
            .contentShape(.rect)
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    currentTab = tab
                }
                
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                    shakeValue = (tab == .video) ? 10 : -10
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                        shakeValue = 0
                    }
                    
                }
            }
    }
    
    @ViewBuilder
    func SampleGridView(_ displayCircle: Bool = false) -> some View {
        ScrollView(.vertical) {
            
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 5), count: 5 )) {
                ForEach(1...30, id: \.self) { _ in
                    Rectangle()
                        .fill(Color("Pink").opacity(0.2))
                        .frame(height: 130)
                        .overlay(alignment: .topTrailing) {
                            if displayCircle {
                                Circle()
                                    .fill(Color("Pink").opacity(0.3))
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                            }
                        }
                } //: LOOP
            } //: LAZY VGRID
            
        } //: SCROLL
        .scrollIndicators(.hidden)
    }
    
    
}

struct CustomCorner: Shape {
    
    var corners: UIRectCorner
    var radius: CGFloat
    
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}

#Preview {
    Home()
}
