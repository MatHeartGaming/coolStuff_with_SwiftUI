//
//  Home.swift
//  Scrollable Tab Bar
//
//  Created by Matteo Buompastore on 24/04/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - Properties
    @State private var tabs: [TabModel] = [
        .init(id: .research),
        .init(id: .deployment),
        .init(id: .analytics),
        .init(id: .audience),
        .init(id: .privacy)
    ]
    @State private var activeTab: TabModel.Tab = .research
    @State private var tabBarScrollState: TabModel.Tab?
    @State private var mainViewScrollState: TabModel.Tab?
    @State private var progress: CGFloat = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            CustomTabBar()
            
            GeometryReader {
                let size = $0.size
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        /// Your Tabs here...
                        ForEach(tabs) { tab in
                            Text(tab.id.rawValue)
                                .frame(width: size.width, height: size.height)
                                .contentShape(.rect)
                        } //: Loop Tabs
                        
                    } //: Lazy HStack
                    .scrollTargetLayout()
                    .rect { rect in
                        progress = -rect.minX / size.width
                    }
                    
                } //: H-SCROLL
                /// Must match the exact type of ID supplied in the ForEach loop!!
                .scrollPosition(id: $mainViewScrollState)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .onChange(of: mainViewScrollState) { oldValue, newValue in
                    if let newValue {
                        withAnimation(.snappy) {
                            tabBarScrollState = newValue
                            activeTab = newValue
                        }
                    }
                }
            }
        } //: VSTACK
        .offset(y: -30)
    }
    
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            
            Spacer(minLength: 0)
            
            /// Buttons
            Button("", systemImage: "plus.circle") {
                
            }
            .font(.title2)
            .tint(.primary)
            
            Button("", systemImage: "bell") {
                
            }
            .font(.title2)
            .tint(.primary)
            
            /// Profile Button
            Button(action: {}, label: {
                Image(.pic)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(.circle)
            })
            
        } //: HSTACK
        .padding(15)
        /// Divider
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
        }
    }
    
    @ViewBuilder
    private func CustomTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach($tabs) { $tab in
                    Button(action: {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            mainViewScrollState = tab.id
                            tabBarScrollState = tab.id
                        }
                    }, label: {
                        Text(tab.id.rawValue)
                            .padding(.vertical, 12)
                            .foregroundStyle(activeTab == tab.id ? Color.primary : .gray)
                            .contentShape(.rect)
                    })
                    .buttonStyle(.plain)
                    .rect { rect in
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            }
            .scrollTargetLayout()
        } //: H-SCROLL
        .scrollPosition(id: .init(get: {
            return tabBarScrollState
        }, set: { _ in
            
        }), anchor: .center)
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                
                let inputRange = tabs.indices.compactMap { return CGFloat($0) }
                let outputRange = tabs.compactMap { return $0.size.width }
                let outputPositionRange = tabs.compactMap { return $0.minX }
                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
            } //: ZSTACK
        }
        .safeAreaPadding(.horizontal, 15)
        .scrollIndicators(.hidden)
    }
    
}

#Preview {
    Home()
}
