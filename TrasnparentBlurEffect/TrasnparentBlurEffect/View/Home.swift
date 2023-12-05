//
//  Home.swift
//  TrasnparentBlurEffect
//
//  Created by Matteo Buompastore on 05/12/23.
//

import SwiftUI

struct Home: View {
    
    // MARK: - View Properties
    @State private var activePic: String = "bg1"
    @State private var blurType: BlurType = .freeStyle
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            
            ScrollView(.vertical) {
                VStack(spacing: 15) {
                    
                    TransparentBlurView(removeAllFilters: true)
                        .blur(radius: 15, opaque: blurType == .clipped)
                        .padding([.horizontal, .top], -30)
                        .frame(height: 100 + safeArea.top)
                        .visualEffect { view, proxy in
                            view
                                .offset(y: proxy.bounds(of: .scrollView)?.minY ?? 0)
                        }
                        /// Placing it above all the views
                        .zIndex(1000)
                    
                    VStack {
                        GeometryReader {
                            let size = $0.size
                            
                            Image(activePic)
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .clipShape(.rect(cornerRadius: 25))
                        } //: GEOMETRY
                        .frame(height: 500)
                        
                        Text("Blur Type")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.top)
                        
                        Picker("", selection: $blurType) {
                            ForEach(BlurType.allCases, id: \.self) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        } //: PICKER
                        .pickerStyle(.segmented)
                    }
                    .padding(15)
                    .padding(.bottom, 500)
                    
                } //: VSTACK
            } //: SCROLL
            .scrollIndicators(.hidden)
            .ignoresSafeArea(.container, edges: .top)
        } //: GEOMETRY SAFE AREA
        
    }
}

enum BlurType: String, CaseIterable {
    case clipped = "Clipped"
    case freeStyle = "Free Style"
}
