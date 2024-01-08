//
//  HOme.swift
//  Trip Planner (ScrollTransition APIs)
//
//  Created by Matteo Buompastore on 08/01/24.
//

import SwiftUI

struct ScrollTransition: View {
    
    // MARK: - UI
    @State private var pickerType: TripPicker = .normal
    @State private var activeID: Int?
    
    var body: some View {
        VStack {
            Picker("", selection: $pickerType) {
                ForEach(TripPicker.allCases, id: \.rawValue) {
                    Text($0.rawValue)
                        .tag($0)
                } //: LOOP TRIP PICKER
            } //: PICKER
            .pickerStyle(.segmented)
            .padding()
            
            Button("Move of two") {
                withAnimation {
                    if let activeID, (activeID + 2) < 9 {
                        self.activeID! += 2
                    } else {
                        self.activeID = 1
                    }
                    print("Index \(self.activeID ?? 0)")
                }
            }
            
            Text("Active ID: \(self.activeID ?? 0)")
                .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            GeometryReader {
                
                let size = $0.size
                let padding = (size.width - 70) / 2
                
                /// Circular Slider
                ScrollView(.horizontal) {
                    HStack(spacing: 35) {
                        ForEach(1...8, id: \.self) { index in
                            Image("Pic \(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(.circle)
                                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
                                .visualEffect { view, proxy in
                                    view
                                        .offset(y: offset(proxy))
                                        .offset(y: scale(proxy) * 15)
                                }
                                .scrollTransition(.interactive, axis: .horizontal) {view, phase in
                                    view
                                        //.offset(y: phase.isIdentity && activeID == index ? 15 : 0)
                                        .scaleEffect(phase.isIdentity && activeID == index && pickerType == .scaled ? 1.5 : 1, anchor: .bottom)
                                }
                                
                            
                        } //: LOOP IMAGES
                    } //: HSTACK
                    .frame(height: size.height)
                    .offset(y: -30)
                    .scrollTargetLayout()
                } //: SCROLL
                .background {
                    if pickerType == .normal {
                        Circle()
                            .fill(.white.shadow(.drop(color: .black.opacity(0.2), radius: 5)))
                            .frame(width: 85, height: 85)
                            .offset(y: -15)
                    }
                }
                .safeAreaPadding(.horizontal, padding) // <-- With this kind of padding the view's minX starts from 0
                .scrollIndicators(.hidden)
                // Snapping
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeID)
                .frame(height: size.height)
                .onAppear {
                    // Place carousel at the middle item
                    activeID = 8/2
                }
                
            } //: GEOMETRY
            .frame(height: 200)
            
        } //: VSTACK
        .ignoresSafeArea(.container, edges: .bottom)
        
    }
    
    
    //MARK: - Functions
    
    func offset(_ proxy: GeometryProxy) -> CGFloat {
        let progress = progress(proxy)
        /// Simply moving view up/down based on progress
        return progress < 0 ? progress * -30 : progress * 30
    }
    
    func scale(_ proxy: GeometryProxy) -> CGFloat {
        let progress = min(max(progress(proxy), -1), 1)
        return progress < 0 ? 1 + progress : 1 - progress
    }
    
    func progress(_ proxy: GeometryProxy) -> CGFloat {
        let viewWidth = proxy.size.width
        let minX = (proxy.bounds(of: .scrollView)?.minX ?? 0)
        return minX / viewWidth
    }
    
}


enum TripPicker: String, CaseIterable {
    case scaled = "Scaled"
    case normal = "Normal"
}

#Preview {
    ScrollTransition()
}
