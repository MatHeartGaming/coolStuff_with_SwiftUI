//
//  Home.swift
//  ScrollableTabView
//
//  Created by Matteo Buompastore on 22/12/23.
//

import SwiftUI

struct Home: View {
    
    // MARK: - UI
    @State private var selectedTab: Tab?
    @Environment(\.colorScheme) private var scheme
    
    /// Tab Progress
    @State private var tabProgress: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                
                Spacer()
                
                Button(action: {}, label: {
                    Image(systemName: "bell.badge")
                })
                
            } //: HSTACK
            .font(.title3)
            .overlay {
                Text("Messages")
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
            
            /// Tab Bar
            CustomTabBar()
            
            GeometryReader {
                let size = $0.size
                
                /// Paging View using new iOS 17 APIs
                ScrollView(.horizontal) {
                    
                    LazyHStack(spacing: .zero) {
                        SampleView(.purple)
                            .id(Tab.chats)
                            .containerRelativeFrame(.horizontal)
                        
                        SampleView(.red)
                            .id(Tab.calls)
                            .containerRelativeFrame(.horizontal)
                        
                        SampleView(.blue)
                            .id(Tab.settings)
                            .containerRelativeFrame(.horizontal)
                    } //: Lazy HStack
                    .scrollTargetLayout()
                    .offsetX { value in
                        /// Converting offset into progress
                        let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                        /// Capping progress 1-0
                        tabProgress = max(min(progress, 1), 0)
                    }
                    
                } //: SCROLL
                .scrollPosition(id: $selectedTab)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            }
            
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.1))
    }
    
    
    // MARK: - Other Views
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: .zero) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Image(systemName: tab.systemImage)
                    
                    Text(tab.rawValue)
                        .font(.callout)
                } //: Tab HStack
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    /// Updating  tab
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            } //: LOOP TABS
        } //: HSTACK
        .tabMask(tabProgress)
        /// Scrollable active tab Indicator
        .background {
            GeometryReader {
                let size = $0.size
                let capusleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capusleWidth)
                    .offset(x: tabProgress * (size.width - capusleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    
    /// Sample View
    @ViewBuilder
    func SampleView(_ color: Color) -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                
                ForEach(1...10, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(color.gradient)
                        .frame(height: 150)
                        .overlay {
                            VStack(alignment: .leading) {
                                Circle()
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 80, height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 60, height: 8)
                                }
                                
                                Spacer(minLength: 0)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 40, height: 8)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                }
            }
            .padding(15)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask {
            Rectangle()
                .padding(.bottom, -100)
        }
    }
    
}

#Preview {
    Home()
}
