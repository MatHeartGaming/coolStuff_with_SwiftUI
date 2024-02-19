//
//  Home.swift
//  Sticky Header Autoscrollable Tabs
//
//  Created by Matteo Buompastore on 19/02/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - Properties
    @State private var activeTab: ProductType = .iphone
    @Namespace private var animation
    @State private var productsBasedOnType: [[Product]] = []
    @State private var animationProgress: CGFloat = .zero
    
    /// Optional
    @State private var scrollableTabOffset: CGFloat = .zero
    @State private var initalOffset: CGFloat = .zero
    
    var body: some View {
        /// For autoscroll content
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                
                /// Using Lazy Vstack to pin view at the top
                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(productsBasedOnType, id: \.self) { products in
                            ProductSectionView(products)
                        } //: Loop Products
                    } header: {
                        ScrollableTabs(proxy)
                    } //: SECTION

                } //: Lazy VSTACK
                
                
                /// In case you don't want LazyVstack
                /*VStack(spacing: 15) {
                    ForEach(productsBasedOnType, id: \.self) { products in
                        ProductSectionView(products)
                    }
                }
                .offset("CONTENTVIEW") { rect in
                    scrollableTabOffset = rect.minY - initalOffset
                }*/
                
            } //: SCROLL
            .scrollIndicators(.hidden)
            
            /// In case you don't want LazyVstack
            /*.offset("CONTENTVIEW") { rect in
                initalOffset = rect.minY
            }
            .safeAreaInset(edge: .top) {
                ScrollableTabs(proxy)
                    .offset(y: scrollableTabOffset > 0 ? scrollableTabOffset : 0)
            }*/
            
        } //: SCROLLVIEW Reader
        /// For Scroll Content offset detection
        .coordinateSpace(name: "CONTENTVIEW")
        .navigationTitle("Apple Store")
        /// Custtm NavBar
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.customPurple, for: .navigationBar)
        /// Dark Scheme for Navbar
        .toolbarColorScheme(.dark, for: .navigationBar)
        .background {
            Rectangle()
                .fill(.BG)
                .ignoresSafeArea()
        }
        .onAppear {
            /// Filtering products based on Product Type
            guard productsBasedOnType.isEmpty else { return }
            for type in ProductType.allCases {
                let products = products.filter { $0.type == type }
                productsBasedOnType.append(products)
            }
        }
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    private func ScrollableTabs(_ proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal) {
            
            HStack(spacing: 10) {
                
                ForEach(ProductType.allCases, id: \.rawValue) { type in
                    
                    Text(type.rawValue)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        /// Active Tab Indicator
                        .background(alignment: .bottom) {
                            if activeTab == type {
                                Capsule()
                                    .fill(.white)
                                    .frame(height: 5)
                                    .padding(.horizontal, -5)
                                    .offset(y: 15)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        } //: Background
                        .padding(.horizontal, 15)
                        .contentShape(.rect)
                        /// Scrolling tabs whenever acrive tab is updated
                        .id(type.tabID)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                activeTab = type
                                /// Avoids weird animation due to the fact active tab was being updated twice
                                animationProgress = 1
                                /// Scrolling to the selected content
                                proxy.scrollTo(type, anchor: .topLeading)
                            }
                        }
                    
                } //: Loop Product Types
                
            } //: HSTACK
            .padding(.vertical, 15)
            .onChange(of: activeTab) { newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newValue.tabID, anchor: .center)
                }
            }
            .checkAnimationEnd(for: animationProgress, completion: {
                /// Resetting animation
                animationProgress = .zero
            })
        } //: SCROLL
        .scrollIndicators(.hidden)
        .background {
            Rectangle()
                .fill(.customPurple)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
        }
        
    }
    
    @ViewBuilder
    private func ProductSectionView(_ products: [Product]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            
            if let firstProduct = products.first {
                Text(firstProduct.type.rawValue)
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            ForEach(products) { product in
                ProductRowView(product)
            }
            
        } //: VSTACK
        .padding(15)
        /// For autoscroll using ScrollViewReader
        .id(products.type)
        .offset("CONTENTVIEW") { rect in
            let minY = rect.minY
            /// When the ContentView reaches its top updarte the current active tab
            if (minY < 30 && -minY < (rect.midY / 2)) && activeTab != products.type && animationProgress == .zero {
                withAnimation(.easeInOut(duration: 0.3)) {
                    /// Safety check
                    activeTab = (minY < 30 && -minY < (rect.midY / 2)) && activeTab != products.type ? products.type : activeTab
                }
            }
        }
    }
    
    @ViewBuilder
    private func ProductRowView(_ product: Product) -> some View {
        HStack(spacing: 15) {
            
            Image(product.productImage)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.white)
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.title3)
                
                Text(product.subtitle)
                    .font(.callout)
                
                Text(product.price)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.customPurple)
                
            } //: VSTACK
            
        } //: HSTACK
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

#Preview {
    NavigationStack {
        Home()
    }
}
