//
//  ContentView.swift
//  Apple Mail App Bar
//
//  Created by Matteo Buompastore on 24/01/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchText: String = ""
    @State private var isSearchActive: Bool = false
    @State private var activeTab: TabModel = .primary
    
    /// Scroll Properties
    @State private var scrollOffset: CGFloat = 0
    @State private var topInsets: CGFloat = 0
    @State private var startTopInsets: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    CustomTabBar(activeTab: $activeTab)
                        .frame(height: isSearchActive ? 0 : nil, alignment: .top)
                        .opacity(isSearchActive ? 0 : 1)
                        .padding(.bottom, isSearchActive ? 0 : 10)
                        .background {
                            let progress = min(max((scrollOffset + startTopInsets - 110) / 15, 0), 1)
                            ZStack(alignment: .bottom) {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                
                                /// Divider
                                Rectangle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(height: 1)
                            } //: ZSTACK
                            .padding(.top, -topInsets)
                            .opacity(progress)
                        }
                        .offset(y: (scrollOffset + topInsets) > 0 ? (scrollOffset + topInsets) : 0)
                        .zIndex(1000)
                    
                    LazyVStack {
                        Text("Hello Mails")
                            .padding(.top)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: Lazy VSTACK
                    .padding(15)
                    .zIndex(0)
                    
                } //: VSTACK
            } //: V-SCROLL
            .animation(.easeInOut(duration: 0.2), value: isSearchActive)
            .onScrollGeometryChange(for: CGFloat.self, of: {
                $0.contentOffset.y
            }, action: { oldValue, newValue in
                scrollOffset = newValue
            })
            .onScrollGeometryChange(for: CGFloat.self, of: {
                $0.contentInsets.top
            }, action: { oldValue, newValue in
                if startTopInsets == .zero {
                    startTopInsets = newValue
                }
                topInsets = newValue
            })
            .navigationTitle("All Inboxes")
            .searchable(text: $searchText, isPresented: $isSearchActive, placement: .navigationBarDrawer(displayMode: .automatic))
            .background(.gray.opacity(0.1))
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        } //: NAVIGATION
    }
}

struct CustomTabBar: View {
    
    @Binding var activeTab: TabModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader {
            let _ = $0.size
            HStack(spacing: 8) {
                HStack(spacing: activeTab == .allMails ? -15 : 8) {
                    ForEach(TabModel.allCases.filter({ $0 != .allMails }), id: \.rawValue) { tab in
                        ResizableTabButton(tab)
                    } //: Loop Tabs
                } //: HSTACK
                
                if activeTab == .allMails {
                    ResizableTabButton(.allMails)
                        .transition(.offset(x: 200))
                }
                
            } //: HSTACK
            .padding(.horizontal, 15)
        } //: GEOMETRY
        .frame(height: 50)
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func ResizableTabButton(_ tab: TabModel) -> some View {
        HStack(spacing: 8) {
            Image(systemName: tab.symbolImage)
                .opacity(activeTab != tab ? 1 : 0)
                .overlay {
                    Image(systemName: tab.symbolImage)
                        .symbolVariant(.fill)
                        .opacity(activeTab == tab ? 1 : 0)
                }
                /// The symbolVariant modifier does not animate well...
                //.symbolVariant(activeTab == tab ? .fill : .none)
            
            if activeTab == tab {
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        } //: HSTACK
        .foregroundStyle(tab == .allMails ? schemeColor : activeTab == tab ? .white : .gray)
        .frame(maxHeight: .infinity)
        .frame(maxWidth: activeTab == tab ? .infinity : nil)
        .padding(.horizontal, activeTab == tab ? 10 : 20)
        .background {
            Rectangle()
                .fill(activeTab == tab ? tab.color : .inactiveTab)
        }
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.background)
                .padding(activeTab == .allMails && tab != .allMails ? -3 : 3)
        }
        .contentShape(.rect)
        .onTapGesture {
            guard tab != .allMails else { return }
            withAnimation(.bouncy) {
                if activeTab == tab {
                    activeTab = .allMails
                } else {
                    activeTab = tab
                }
            }
        }
    }
    
    var schemeColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
}

#Preview {
    ContentView()
}
