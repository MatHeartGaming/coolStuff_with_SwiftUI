//
//  Home.swift
//  Apple Music Bottom Sheet Animation
//
//  Created by Matteo Buompastore on 16/02/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - Properties
    @State private var expandSheet: Bool = false
    @Namespace private var animation
    
    var body: some View {
        TabView {
            
            ListenNow()
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Listen Now")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                /// Hiding Tab Bar when sheet is expaned
                .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
            SampleTabView(title: "Browse", icon: "square.grid.2x2.fill")
            SampleTabView(title: "Radio", icon: "dot.radiowaves.left.and.right")
            SampleTabView(title: "Music", icon: "play.square.stack")
            SampleTabView(title: "Search", icon: "magnifyingglass")
            
        } //: TABVIEW
        /// Chaning Tab Indicator Color
        .tint(.red)
//        .toolbarBackground(.visible, for: .tabBar)
//        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            CustomBottomSheet()
        }
        .overlay {
            if expandSheet {
                ExpandedBottomSheet(expandSheet: $expandSheet, animation: animation)
                /// Transition for smooth animation
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        }
    }
    
    
    
    // MARK: - Views
    
    private func SampleTabView(title: String, icon: String) -> some View {
        /// SwiftUI bug of View not animating can be solved by wrapping this TabItem in a ScrollView
        ScrollView(.vertical) {
            Text(title)
                .padding(.top, 25)
        }
        .scrollIndicators(.hidden)
        .tabItem {
            Image(systemName: icon)
            Text(title)
        }
        /// It should work when applied to TabView but it's not, so apply it to every single TabItem
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        /// Hiding Tab Bar when sheet is expaned
        .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
    }
    
    @ViewBuilder
    private func CustomBottomSheet() -> some View {
        ZStack {
            
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
            
        } //: ZSTACK
        .frame(height: 70)
        /// Separator Line
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
        }
        /// 49 is the default Tab Bar Height
        .offset(y: -49)
    }
    
    @ViewBuilder
    func ListenNow() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    Image(.card1)
                        .resizable()
                        .scaledToFit()
                    
                    Image(.card2)
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 15, style: .continuous))
                } //: VSTACK
                .padding()
                .padding(.bottom, 100)
            } //: V-SCROLL
            .scrollIndicators(.hidden)
        } //: NAVIGATION
    }
    
}

#Preview {
    Home()
        .preferredColorScheme(.dark)
}
