//
//  Home.swift
//  Expandable Navigation SearchBar
//
//  Created by Matteo Buompastore on 02/05/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - Properties
    @State private var searchText: String = ""
    @FocusState private var isSearching: Bool
    @State private var activeTab: Tab = .all
    @Environment(\.colorScheme) private var scheme
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                DummyMessagesView()
            } //: Lazy V-STACK
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                ExpandableNavigationBar()
            }
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearching)
        } //: V-SCROLL
        .scrollTargetBehavior(CustomScrollTargetBehaviour())
        .background(.gray.opacity(0.15))
        /// To avioid the scroll Indicator to go on to the NavBar
        .contentMargins(.top, 190, for: .scrollIndicators)
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func ExpandableNavigationBar(_ title: String = "Messages") -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
            let scaleProgress = minY > 0 ? 1 + (max(min((minY / scrollViewHeight), 1), 0) * 0.5) : 1
            /// 70 is a random value. The lower the faster the scroll will be.
            let progress = isSearching ? 1 : max(min(-minY / 70, 1), 0)
            
            VStack(spacing: 10) {
                
                /// Title
                Text(title)
                    .font(.largeTitle.bold())
                    .scaleEffect(scaleProgress, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    
                    TextField("Search Conversations", text: $searchText)
                        .focused($isSearching)
                    
                    if isSearching {
                        Button {
                            isSearching = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                        }
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))

                    }
                } //: HSTACK
                .foregroundStyle(Color.primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 15 - (progress * 15))
                .frame(height: 45)
                .clipShape(.capsule)
                .background {
                    RoundedRectangle(cornerRadius: 25 - (progress * 25))
                        .fill(.background)
                        .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                        .padding(.top, -progress * 190)
                        .padding(.bottom, -progress * 65)
                        .padding(.horizontal, -progress * 15)
                }
                
                /// Custom Tabs
                ScrollView(.horizontal) {
                    
                    HStack(spacing: 12) {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            Button(action: {
                                withAnimation(.snappy) {
                                   activeTab = tab
                                }
                            }, label: {
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(activeTab == tab ? (scheme == .dark ? .black : .white) : Color.primary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 15)
                                    .background {
                                        if activeTab == tab {
                                            Capsule()
                                                .fill(Color.primary)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        } else {
                                            Capsule()
                                                .fill(.background)
                                        }
                                    }
                            })
                            .buttonStyle(.plain)
                        }
                    }
                } //: H-Scroll
                .frame(height: 50)
                
            } //: VSTACK
            .padding(.top, 25)
            .safeAreaPadding(.horizontal, 15)
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * 65)
        } //: GEOMETRY
        /// Sum of all the components in the nav bar
        .frame(height: 190)
        .padding(.bottom, 10)
        .padding(.bottom, isSearching ? -65 : 0)
    }
    
    @ViewBuilder
    private func DummyMessagesView() -> some View {
        ForEach(0..<20, id: \.self) { _ in
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading, spacing: 6) {
                    Rectangle()
                        .frame(width: 140, height: 8)
                    
                    Rectangle()
                        .frame(height: 8)
                    
                    Rectangle()
                        .frame(width: 80, height: 8)
                } //: VSTACK
            } //: HSTACK
            .foregroundStyle(.gray.opacity(0.4))
            .padding(.horizontal, 15)
        } //: Loop
    }
}

struct CustomScrollTargetBehaviour: ScrollTargetBehavior {
    
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 70 {
            if target.rect.minY < 35 {
                target.rect.origin = .zero
            } else {
                target.rect.origin = .init(x: 0, y: 70)
            }
        }
    }
    
}

#Preview {
    Home()
}
