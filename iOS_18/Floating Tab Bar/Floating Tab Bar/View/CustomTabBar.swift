//
//  CustomTabBar.swift
//  Floating Tab Bar
//
//  Created by Matteo Buompastore on 26/08/24.
//

import SwiftUI

struct CustomTabBar: View {
    
    // MARK: - Properties
    var activeForeground: Color = .white
    var activeBackground: Color = .blue
    @Binding var activeTab: TabModel
    
    /// Matched Geometry FX
    @Namespace private var animation
    
    @State private var tabLocation: CGRect = .zero
    
    var body: some View {
        let status = activeTab == .home || activeTab == .search
        
        HStack(spacing: !status ? 0 : 12) {
            HStack(spacing: 0) {
                ForEach(TabModel.allCases, id: \.rawValue) { tab in
                    Button {
                        activeTab = tab
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: tab.rawValue)
                                .font(.title3)
                                .frame(width: 30, height: 30)
                            
                            if activeTab == tab {
                                Text(tab.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                        } //: HSTACK
                        .foregroundStyle(activeTab == tab ? activeForeground : .gray)
                        .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 15))
                        .contentShape(.rect)
                        .background {
                            if activeTab == tab {
                                Capsule()
                                    .fill(activeBackground.gradient)
                                    .onGeometryChange(for: CGRect.self, of: {
                                        $0.frame(in: .named("TABBARVIEW"))
                                    }, action: { newValue in
                                        tabLocation = newValue
                                    })
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    
                } //: Loop Tab
            } //: HSTACK
            .background(alignment: .leading) {
                Capsule()
                    .fill(activeBackground.gradient)
                    .frame(width: tabLocation.width, height: tabLocation.height)
                    .offset(x: tabLocation.minX)
            }
            .coordinateSpace(.named("TABBARVIEW"))
            .padding(.horizontal, 5)
            .frame(height: 45)
            .background(
                .background
                    .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
                    .shadow(.drop(color: .black.opacity(0.06), radius: 5, x: -5, y: -5)),
                in: .capsule
            )
            .zIndex(10)
            
            Button {
                if activeTab == .home {
                    print("Profile")
                } else {
                    print("Microphone")
                }
            } label: {
                MorphingSymbolView(symbol: activeTab == .home ? "person.fill" : "mic.fill",
                                   config: .init(font: .title3,
                                                 frame: .init(width: 42, height: 42),
                                                 radius: 2, foregroundColor: activeForeground,
                                                 keyFrameDuration: 0.3, .smooth(duration: 0.3, extraBounce: 0))
                )
                Image(systemName: activeTab == .home ? "person.fill" : "slider.vertical.3")
                    .font(.title3)
                    .frame(width: 42, height: 42)
                    .foregroundStyle(activeForeground)
                    .background(activeBackground.gradient)
                    .clipShape(.circle)
            }
            .allowsHitTesting(status)
            .offset(x: status ? 0 : -20)
            .padding(.leading, status ? 0 : -42)
            
        } //: HSTACK
        .padding(.bottom, 5)
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
    }
}

#Preview {
    CustomTabBar(activeTab: .constant(.home))
}

#Preview("Content View") {
    ContentView()
}
