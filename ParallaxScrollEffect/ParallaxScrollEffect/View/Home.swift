//
//  Home.swift
//  ParallaxScrollEffect
//
//  Created by Matteo Buompastore on 02/01/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                DummySection(title: "Social Media")
                
                DummySection(title: "Sales", isLong: true)
                
                /// Parallax
                ParallaxImageView(useFullWidth: true) { size in
                    Image(.pic1)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 300)
                
                DummySection(title: "Business", isLong: true)
                
                DummySection(title: "Promotions", isLong: true)
                
                ParallaxImageView(maximumMovement: 200, useFullWidth: false) { size in
                    Image(.pic2)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 350)
                
                
                DummySection(title: "Youtube")
                
                DummySection(title: "Twitter (X)")
                
                
                // Parallax
                
            } //: Lazy VStack
            .padding(15)
        } //: SCROLL
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    func DummySection(title: String, isLong: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title.bold())
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque tempor ligula lorem, id vehicula mauris venenatis ac. Donec risus metus, cursus pulvinar massa nec, consectetur aliquet lorem. Vivamus neque nisi, ornare et erat non, lacinia suscipit orci. \(isLong ? "Curabitur tempus massa sed massa pharetra, a luctus mi sagittis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Proin tristique, mauris ac feugiat mattis, ex lacus imperdiet ligula, vitae varius tortor turpis at mi. Ut nisi odio, pharetra eget libero eget, blandit sodales arcu. Integer bibendum augue nec fringilla tempus. Sed semper nibh ac leo pellentesque, eu pulvinar lectus facilisis. Nulla sodales tristique tellus eget interdum. Morbi mollis ultrices lacus ac ornare. Donec ut ipsum posuere, dapibus nisl non, aliquam lacus. Donec malesuada mi eget mi accumsan, vel mollis arcu finibus. Nam tincidunt tempor nisl in luctus. Morbi luctus erat enim, quis consequat urna viverra at. Quisque et vulputate justo." : "")")
                .multilineTextAlignment(.leading)
                .kerning(1.2)
        } //: VSTACK
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

struct ParallaxImageView<Content: View>: View {
    
    var maximumMovement: CGFloat = 100
    var useFullWidth: Bool = false
    @ViewBuilder var content: (CGSize) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            /// Movement animation Properties
            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHight = $0.bounds(of: .scrollView)?.size.height ?? 0
            let maximumMovement = min(maximumMovement, (size.height * 0.35))
            let stretchedSize: CGSize = .init(width: size.width, height: size.height + maximumMovement)
            
            let progress = minY / scrollViewHight
            let cappedProgress = max(min(progress, 1), -1)
            let movementOffset = cappedProgress * -maximumMovement
            
            content(size)
                .offset(y: movementOffset)
                .frame(width: stretchedSize.width, height: stretchedSize.height)
                .frame(width: size.width, height: size.height)
        } //: GEOMETRY
        .containerRelativeFrame(useFullWidth ? [.horizontal] : [])
    }
    
}

#Preview {
    Home()
}
