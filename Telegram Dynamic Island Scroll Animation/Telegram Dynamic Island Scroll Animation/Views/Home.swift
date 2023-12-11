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
    @Environment(\.colorScheme) private var colorScheme
    @State private var textHeaderOffset: CGFloat = .zero
    
    var body: some View {
        let hasNotch = safeArea.hasNotch()
        ScrollView(.vertical, showsIndicators: true) {
            
            VStack(spacing: 12) {
                
                Image(.pic)
                    .resizable()
                    .scaledToFill()
                    /// Adding blur and reducing size based on scroll progress
                    .frame(width: 130 - (75 * scrollProgress), height: 130 - (75 * scrollProgress))
                    /// Hiding Mina view so that Dynamic Island Metaball effect will be visible
                    .opacity(1 - scrollProgress)
                    .blur(radius: scrollProgress * 10, opaque: true)
                    .clipShape(.circle)
                    .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                        return ["HEADER": anchor]
                    })
                    .padding(.top, safeArea.top + 15)
                    .offsetExtractor(coordinateSpace: "SCROLLVIEW") { scrollRect in
                        guard hasNotch else { return }
                        let progress = -scrollRect.minY / 25
                        scrollProgress = min(max(progress, 0), 1)
                    }
                
                let fixedTop: CGFloat = safeArea.top + 3
                Text("MatBuompy - Mobile Developer")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 15)
                    .background(
                        Rectangle()
                            .fill(colorScheme == .dark ? .black : .white)
                            .frame(width: size.width)
                            .padding(.top, textHeaderOffset < fixedTop ? -safeArea.top : .zero)
                            .shadow(color: .black.opacity(textHeaderOffset < fixedTop ? 0.1 : 0), radius: 5, x: 0, y: 5)
                    )
                    /// Stopping at the top
                    .offset(y: textHeaderOffset < fixedTop ? -(textHeaderOffset - fixedTop) : .zero)
                    .offsetExtractor(coordinateSpace: "SCROLVIEW") { scroll in
                        textHeaderOffset = scroll.minY
                    }
                    .zIndex(1000)
                
                SampleRows()
                
            } //: VSTACK
            .frame(maxWidth: .infinity)
            
        } //: SCROLL
        .backgroundPreferenceValue(AnchorKey.self) { pref in
            GeometryReader { proxy in
                if let anchor = pref["HEADER"], hasNotch {
                    let frameRect = proxy[anchor]
                    let hasDynamicIsland = safeArea.hasDynamicIsland()
                    let capusuleHeight = hasDynamicIsland ? 37 : (safeArea.top + 15)
                    Canvas { out, size in
                        
                        out.addFilter(.alphaThreshold(min: 0.5))
                        out.addFilter(.blur(radius: 12))
                        
                        out.drawLayer { ctx in
                            if let headerView = out.resolveSymbol(id: 0) {
                                ctx.draw(headerView, in: frameRect)
                            }
                            
                            if let dynamicIsland = out.resolveSymbol(id: 1) {
                                /// Placing Dynamic Island
                                let rect = CGRect(x: (size.width - 120) / 2, 
                                                  y: hasDynamicIsland ? 11 : 0,
                                                  width: 120,
                                                  height: capusuleHeight)
                                ctx.draw(dynamicIsland, in: rect)
                            }
                        }
                        
                    } symbols: {
                        HeaderView(frameRect)
                            .tag(0)
                            .id(0)
                        
                        DynamicIslandCapsule(capusuleHeight)
                            .tag(1)
                            .id(1)
                    }
                }
            } //: GEOMETRY
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(colorScheme == .dark ? .black : .white)
                    .frame(height: 15)
            }
        } //: BACKGROUND PREF KEY
        .overlay(alignment: .top) {
            HStack {
                Button(action: {}, label: {
                    Label("Back", systemImage: "chevron.left")
                })
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Edit")
                }

            } //: HSTACK
            .padding(15)
            .padding(.top, safeArea.top)
        }
        .coordinateSpace(name: "SCROLLVIEW")
    }
    
    
    /// Canvas Symbols
    @ViewBuilder
    func HeaderView(_ frameRect: CGRect) -> some View {
        Circle()
            .fill(.black)
            .frame(width: frameRect.width, height: frameRect.height)
    }
    
    @ViewBuilder
    func DynamicIslandCapsule(_ height: CGFloat = 37) -> some View {
        Capsule()
            .fill(.black)
            .frame(width: 120, height: height)
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
    /*Home(size: .init(width: 400, height: 200),
         safeArea: .init(top: 10, leading: 10, bottom: 10, trailing: 10))*/
    ContentView()
}
