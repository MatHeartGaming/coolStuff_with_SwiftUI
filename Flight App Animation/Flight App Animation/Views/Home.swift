//
//  Home.swift
//  Flight App Animation
//
//  Created by Matteo Buompastore on 15/02/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - Properties
    let size: CGSize
    let safeArea: EdgeInsets
    
    /// Gesture
    @State private var offsetY: CGFloat = 0
    @State private var currentCardIndex: CGFloat = 0
    
    /// Animator
    @StateObject private var animator = Animator()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .overlay(alignment: .bottomTrailing) {
                    Button(action: {}, label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .frame(width: 40, height: 40)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.35), radius: 5, x: 5, y: 5)
                            }
                    })
                    .offset(x: -15, y: 15)
                    .offset(x: animator.startAnimation ? 80 : 0)
                }
                .zIndex(1)
            PaymentCardView()
                .zIndex(0)
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ZStack(alignment: .bottom) {
                ZStack {
                    if animator.showClouds {
                        /// Cloud Views
                        CloudView(delay: 1, size: size)
                            .offset(y: size.height * -0.1)
                        CloudView(delay: 0, size: size)
                            .offset(y: size.height * 0.3)
                        CloudView(delay: 2.5, size: size)
                            .offset(y: size.height * 0.2)
                        CloudView(delay: 2.5, size: size)
                    }
                }
                .frame(maxHeight: .infinity)
                
                if animator.showLoadingView {
                    BackgroundView()
                        .transition(.scale)
                        .opacity(animator.showFinalView ? 0 : 1)
                }
            }
        }
        .allowsHitTesting(!animator.showFinalView)
        .background {
            /// Safety check
            if animator.startAnimation {
                DetailView(size: size, safeArea: safeArea)
                    .environmentObject(animator)
            }
        }
        .overlayPreferenceValue(RectKey.self, { value in
            if let anchor = value["PLANE_BOUNDS"] {
                GeometryReader { proxy in
                    /// Extracting Rect from Anchor using Geometry Reader
                    let rect = proxy[anchor]
                    let planeRect = animator.initalPlanePosition
                    let status = animator.currentPaymentStatus
                    
                    /// Resetting Plane when Final View shows
                    let animationStatus = status == .finished && !animator.showFinalView
                    
                    Image(.airplane)
                        .resizable()
                        .scaledToFit()
                        .frame(width: planeRect.width, height: planeRect.height)
                        /// Flight movement animation
                        .rotationEffect(.degrees(animationStatus ? -10 : 0))
                        .shadow(color: .black.opacity(0.25),
                                radius: 1,
                                x: status == .finished ? -400 : 0,
                                y: status == .finished ? 170 : 0)
                        .offset(x: planeRect.minX, y: planeRect.minY)
                        /// Moving plane a bit down at the start of the animation
                        .offset(y: animator.startAnimation ? 50 : 0)
                        .scaleEffect(animator.showFinalView ? 0.9 : 1, anchor: .bottom)
                        .offset(y: animator.showFinalView ? 55 : 0)
                        .onAppear {
                            animator.initalPlanePosition = rect
                        }
                        .animation(.easeInOut(duration: animationStatus ? 3.5 : 3.5), value: animationStatus)
                }
            }
        })
        /// Overlayed Cloud over the airplane
        .overlay {
            if animator.showClouds {
                CloudView(delay: 2.2, size: size)
                    .offset(y: -size.height * 0.25)
            }
        } //: Cloud Overlay
        .background {
            Color.BG
                .ignoresSafeArea()
        } //: Background
        ///When the payment status changes to finished toggle clouds
        .onChange(of: animator.currentPaymentStatus) { newValue in
            if newValue == .finished {
                animator.showClouds = true
                
                /// Showing final View
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animator.showFinalView = true
                    }
                }
            }
        }
        
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            Image(.logo)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.white)
                .scaledToFit()
                .frame(width: size.width * 0.4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                FlightDetailsView(place: "Napoli", code: "NAC", timing: "24 Jul, 11:00")
                
                VStack(spacing: 8) {
                    
                    Image(systemName: "chevron.right")
                        .font(.title2)
                    
                    Text("2h 25m")
                    
                } //: VSTACK
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                
                FlightDetailsView(alignment: .trailing, place: "Dublin", code: "DUB", timing: "24 Jul, 13:25")
            } //: HSTACK
            .padding(.bottom, -15)
            
            /// Airplane Image
            Image(.airplane)
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .opacity(0)
                .anchorPreference(key: RectKey.self, value: .bounds, transform: { anchor in
                    return ["PLANE_BOUNDS": anchor]
                })
                .padding(.bottom, -20)
            
        } //: VSTACK
        .padding([.horizontal, .top], 15)
        .background {
            Rectangle()
                .fill(.linearGradient(colors: [
                    .blueTop,
                    .blueTop,
                    .blueBottom
                ],
                                      startPoint: .top,
                                      endPoint: .bottom))
        } //: Background
        /// 3D rotation
        .rotation3DEffect(.degrees(animator.startAnimation ? 90 : 0),
                          axis: (x: 1, y: 0, z: 0),
                          anchor: UnitPoint(x: 0.5, y: 0.8))
        .offset(y: animator.startAnimation ? -100 : 0)
    }
    
    @ViewBuilder
    private func PaymentCardView() -> some View {
        VStack {
            Text("SELECT PAYMENT METHOD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.vertical)
            
            GeometryReader { _ in
                VStack(spacing: 0) {
                    ForEach(sampleCards.indices, id: \.self) { index in
                        CardView(index: index)
                    } //: Loop Cards
                } //: VSTACK
                .padding(.horizontal, 30)
                .offset(y: offsetY)
                .offset(y: currentCardIndex * -200)
                
                /// Gradient View
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .white.opacity(0.3),
                        .white.opacity(0.7),
                        .white
                    ], startPoint: .top, endPoint: .bottom))
                    /// Since the Rectangle is on top of the Cards it will prevent tapping, so we disable hit testing on it.
                    .allowsHitTesting(false)
                
                /// Purchase Button
                Button(action: buyTicket, label: {
                    Text("Confirm €320.00")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(.blueTop.gradient)
                        }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, safeArea.bottom == 0 ? 15 : safeArea.bottom)
                
                
            } //: GEOMETRY
            .coordinateSpace(name: "SCROLL")
        } //: VSTACK
        .contentShape(.rect)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    /// Decreasing speed
                    offsetY = value.translation.height * 0.3
                })
                .onEnded({ value in
                    let translation = value.translation.height
                    withAnimation(.easeInOut) {
                        /// Increasing / Decreasing index on condition
                        if translation > 100 && currentCardIndex > 0 {
                            currentCardIndex -= 1
                        } else if translation < 0 && -translation > 100 && currentCardIndex < CGFloat(sampleCards.count - 1) {
                            currentCardIndex += 1
                        }
                        
                        offsetY = .zero
                    }
                })
        ) //: Card Gesture
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .clipped()
        /// Applying 3D rotation
        .rotation3DEffect(.degrees(animator.startAnimation ? -90 : 0),
                          axis: (x: 1, y: 0, z: 0),
                          anchor: UnitPoint(x: 0.5, y: 0.25))
        .offset(y: animator.startAnimation ? 100 : 0)
    }
    
    @ViewBuilder
    private func CardView(index: Int) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / size.height
            let contrainedProgress = progress > 1 ? 1 : (progress < 0) ? 0 : progress
            
            Image(sampleCards[index].cardImage)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                /// Shadow
                .shadow(color: .black.opacity(0.14), radius: 8, x: 6, y: 6)
                /// Stacked Animation
            .rotation3DEffect(
                .degrees(contrainedProgress * 40.0),
                axis: (x: 1, y: 0, z: 0.0), anchor: .bottom)
                .padding(.top, progress * -160)
                /// Moving current Card to the Top
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
        .onTapGesture {
            print(index)
        }
    }
    
    /// Background Loading View with Ring animation
    @ViewBuilder
    private func BackgroundView() -> some View {
        VStack {
            VStack(spacing: 9) {
                ForEach(PaymentStatus.allCases, id: \.self) { status in
                    Text(status.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray.opacity(0.5))
                        .frame(height: 30)
                } //: Loop Payment status
            } //: VSTACK
            .offset(y: animator.currentPaymentStatus == .started ? -30 
                    : (animator.currentPaymentStatus == .finished ? -80 : 0))
            .frame(height: 40, alignment: .top)
            .clipped()
            
            ZStack {
                /// Rings
                
                Circle()
                    .fill(.BG)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[0] ? 5: 1)
                    /// To gradually dissolve the ring as it expands
                    .opacity(animator.ringAnimation[0] ? 0 : 1)
                
                Circle()
                    .fill(.BG)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[1] ? 5: 1)
                    /// To gradually dissolve the ring as it expands
                    .opacity(animator.ringAnimation[1] ? 0 : 1)
                
                
                Circle()
                    .fill(.BG)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    .scaleEffect(1.22)
                
                Circle()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                
                Image(systemName: animator.currentPaymentStatus.symbolImage)
                    .font(.largeTitle)
                    .foregroundStyle(.gray.opacity(0.5))
                
            } //: ZSTACK
            .frame(width: 80, height: 80)
            .padding(.top, 20)
            
        } //: VSTACK
        /// Using Timer to perform Loading effect
        .onReceive(Timer.publish(every: 2.3, on: .main, in: .common).autoconnect(), perform: { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                if animator.currentPaymentStatus == .initiated {
                    animator.currentPaymentStatus = .started
                } else {
                    animator.currentPaymentStatus = .finished
                }
            }
        })
        .onAppear {
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                animator.ringAnimation[0] = true
            }
            
            withAnimation(.linear(duration: 2.5).delay(0.35).repeatForever(autoreverses: false)) {
                animator.ringAnimation[1] = true
            }
        }
        //.frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, size.height * 0.15)
    }
    
    
    // MARK: - Functions
    
    func buyTicket() {
        withAnimation(.easeInOut(duration: 0.85)) {
            animator.startAnimation = true
        }
        
        /// Show Loading View
        withAnimation(.easeInOut(duration: 0.7).delay(0.5)) {
            animator.showLoadingView = true
        }
        
    }
    
}

#Preview {
    GeometryReader {
        let size = $0.size
        let safeArea = $0.safeAreaInsets
        Home(size: size, safeArea: safeArea)
            .ignoresSafeArea(.container, edges: .vertical)
    }
}
