//
//  Home.swift
//  Telegram Dynamic Island Scroll Animation
//
//  Created by Matteo Buompastore on 11/12/23.
//

import SwiftUI

struct Home: View {
    
    // MARK: - PROPERTIES
    var size: CGSize
    var safeArea: EdgeInsets
    
    /// UI Properties
    @State private var scrollProgress: CGFloat = .zero
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            
            VStack(spacing: 12) {
                
                Image(.pic)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(.circle)
                    .offsetExtractor(coordinateSpace: "SCROLLVIEW") { scrollRect in
                        scrollProgress = scrollRect.minY
                    }
                
                Text("MatBuompy - Mobile Developer \(scrollProgress)")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 15)
                
            } //: VSTACK
            .padding(.top, safeArea.top + 15)
            .frame(maxWidth: .infinity)
            
            SampleRows()
            
        } //: SCROLL
        .coordinateSpace(name: "SCROLLVIEW")
    }
    
    
    /// Sample Rows
    @ViewBuilder
    func SampleRows() -> some View {
        VStack {
            ForEach(1...20, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 25)
                    
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 15)
                        .padding(.trailing, 50)
                    
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 15)
                        .padding(.trailing, 150)
                } //: VSTACK
            } //: LOOP
        } //: VSTACK
        .padding(.horizontal, 15)
        .padding(.bottom, safeArea.bottom + 15)
        
    }
    
}

#Preview {
    Home(size: .init(width: 400, height: 200),
         safeArea: .init(top: 10, leading: 10, bottom: 10, trailing: 10))
}
