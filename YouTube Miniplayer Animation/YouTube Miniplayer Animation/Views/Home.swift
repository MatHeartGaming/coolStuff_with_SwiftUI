//
//  Home.swift
//  YouTube Miniplayer Animation
//
//  Created by Matteo Buompastore on 26/02/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - Properties
    @State private var activeTab: Tab = .home
    @State private var config: PlayerConfig = .init()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                HomeTabView()
                    .setupTab(.home)
                
                Text(Tab.shorts.rawValue)
                    .setupTab(.shorts)
                
                Text(Tab.subscriptions.rawValue)
                    .setupTab(.subscriptions)
                
                Text(Tab.you.rawValue)
                    .setupTab(.you)
            } //: TABVIEW
            .padding(.bottom, tabBarHeight)
            
            /// Mini Player
            GeometryReader {
                let size = $0.size
                if config.showMiniPlayer {
                    MiniPlayer(size: size, config: $config) {
                        withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete) {
                            config.showMiniPlayer = false
                        } completion: {
                            config.resetPostion()
                            config.selectedPlayerItem = nil
                        }
                    }
                }
            } //: GEOMETRY
            
            CustomTabBar()
                .offset(y: config.showMiniPlayer ? tabBarHeight - (config.progress * tabBarHeight) : 0)
            
        } //: ZSTACK
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    func HomeTabView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                
                LazyVStack(spacing: 15) {
                    ForEach(items) { item in
                        PlayerItemCardView(item) {
                            config.selectedPlayerItem = item
                            withAnimation(.easeInOut(duration: 0.3)) {
                                config.showMiniPlayer = true
                            }
                        }
                    } //: Loop Player Items
                }
                .padding(15)
                
            } //: V-SCROLL
            .scrollIndicators(.hidden)
            .navigationTitle("YouTube")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.background, for: .navigationBar)
        } //: NAVIGATION
    }
    
    @ViewBuilder
    func PlayerItemCardView(_ item: PlayerItem, onTap: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipShape(.rect(cornerRadius: 10))
                .contentShape(.rect)
                .onTapGesture(perform: onTap)
            
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.callout)
                    
                    HStack(spacing: 6) {
                        Text(item.author)
                        
                        Text("2 Days ago")
                    } //: HSTACK
                    .font(.caption)
                    .foregroundStyle(.gray)
                    
                } //: VSTACK
                
            } //: HSTACK
        } //: VSTACK
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.symbol)
                        .font(.title3)
                    
                    Text(tab.rawValue)
                        .font(.caption2)
                }
                .foregroundStyle(activeTab == tab ? Color.primary : .gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    activeTab = tab
                }
            } //: LOOP TABS
        } //: HSTACK
        .frame(height: 49)
        .overlay(alignment: .top) {
            Divider()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(height: tabBarHeight)
        .background(.background)
    }
}

// MARK: - View Extensions

extension View {
    
    @ViewBuilder
    func setupTab(_ tab: Tab) -> some View {
        self
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
    
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    
    var tabBarHeight: CGFloat {
        return 49 + safeArea.bottom
    }
    
}


// MARK: - Preview
#Preview {
    Home()
}
