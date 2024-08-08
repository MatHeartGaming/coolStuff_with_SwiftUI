//
//  CustomPagingIndicatorView.swift
//  Photos App UI
//
//  Created by Matteo Buompastore on 08/08/24.
//

import SwiftUI

struct CustomPagingIndicatorView: View {
    
    // MARK: Properties
    var onClose: () -> Void
    @Environment(SharedData.self) private var sharedData
    @Namespace private var animation
    
    var body: some View {
        let progress = sharedData.progress
        HStack(spacing: 8) {
            ForEach(1...4, id: \.self) { index in
                Circle()
                    .opacity(index == 1 ? 0 : 1)
                    .overlay {
                        /// For the photos page view let's use a Grid Symbool
                        if index == 1 {
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.system(size: 10))
                        }
                    }
                    .frame(width: 7, height: 7)
                    .foregroundStyle(sharedData.activePage == index ? Color.primary : .gray)
            } //: Loop
        } //: HSTACK
        .blur(radius: progress * 5)
        .opacity(1.0 - (progress * 4))
        .overlay(alignment: .center) {
            CustomBottomBar()
                .fixedSize()
                .blur(radius:(1 - progress) * 5)
                .opacity(progress)
        }
        .offset(y: -30 - (30 * progress))
    }
    
    
    @ViewBuilder
    func CustomBottomBar() -> some View {
        HStack(spacing: 10) {
            HStack(spacing: 0) {
                ForEach(["Years", "Month", "All"], id: \.self) { category in
                    Button {
                        withAnimation(.snappy) {
                            sharedData.selectedCategory = category
                        }
                    } label: {
                        Text(category)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 6)
                            .background {
                                if sharedData.selectedCategory == category {
                                    Capsule()
                                        .fill(.gray.opacity(0.15))
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                }
                            }
                    }

                }
            } //: HSTACK
            .background(.ultraThinMaterial, in: .capsule)
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .frame(width: 35, height: 35)
                    .background(.ultraThinMaterial, in: .circle)
            }

        } //: HSTACK
        .foregroundStyle(Color.primary)
    }
}

#Preview {
    CustomPagingIndicatorView {
        
    }
    .environment(SharedData())
}

#Preview {
    ContentView()
}
