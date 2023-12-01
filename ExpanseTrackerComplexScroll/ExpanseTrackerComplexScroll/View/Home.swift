//
//  Home.swift
//  ExpanseTrackerComplexScroll
//
//  Created by Matteo Buompastore on 01/12/23.
//

import SwiftUI

struct Home: View {
    
    // MARK: - PROPERTIES
    @State private var allExpenses: [Expense] = []
    @State private var activeCard: UUID?
    
    /// Environment values
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Hello Matteo!")
                        .frame(height: 45)
                        .font(.largeTitle.bold())
                        .padding(.horizontal, 15)
                    
                    GeometryReader {
                        let rect = $0.frame(in: .scrollView)
                        let minY = rect.minY.rounded()
                        
                        /// Card View
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(cards) { card in
                                    ZStack {
                                        if minY == 75.0 {
                                            /// Not scrolled
                                            CardView(card)
                                        } else {
                                            /// Scrolled. Hiding other cards
                                            if activeCard == card.id {
                                                CardView(card)
                                            } else {
                                                Rectangle()
                                                    .fill(.clear)
                                            }
                                        }
                                    }
                                    .containerRelativeFrame(.horizontal)
                                        
                                } //: CARD LOOP
                            } // Lazy HStack
                            .scrollTargetLayout()
                        } //: H ScrollView
                        .scrollPosition(id: $activeCard)
                        .scrollTargetBehavior(.paging)
                        .scrollClipDisabled()
                        .scrollIndicators(.hidden)
                        .scrollDisabled(minY != 75.0)
                        
                    } //: GEOMETRY
                    .frame(height: 125)
                    
                } //: VSTACK
                
                
                
                LazyVStack(spacing: 15) {
                    
                    Menu {
                        
                    } label: {
                        HStack(spacing: 4) {
                            Text("Filter By")
                            Image(systemName: "chevron.down")
                        } //: HSTACK
                        .font(.caption)
                        .foregroundStyle(.gray)
                    } //: MENU
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(allExpenses) { expense in
                        ExpenseCardView(expense)
                    }

                    
                } //: LazyVStack
                .padding(15)
                .mask {
                    MaskingRectangle()
                }
                .background {
                    GeometryReader { geom in
                        let rect = geom.frame(in: .scrollView)
                        let minY = min(rect.minY - 125, 0)
                        let progress = max(min(-minY / 25, 1), 0)
                        MaskingRectangle(cornerRadiusMultiplier: progress)
                    }
                }
                
            } //: VSTACK
            .padding(.vertical, 15)
        } //: SCROLLVIEW
        .scrollTargetBehavior(CustomScrollBehaviour())
        .scrollIndicators(.hidden)
        .onAppear {
            if activeCard == nil {
                activeCard = cards.first?.id
            }
        }
        .onChange(of: activeCard) { oldValue, newValue in
            withAnimation(.snappy) {
                allExpenses = expenses.shuffled()
            }
        }
    }
    
    /// Background limit effect
    func backgroundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        return minY < 100 ? -minY + 100 : 0
    }
    
    // MARK: - ViewBuilder FUNCTIONS
    
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        GeometryReader { geometry in
            let rect = geometry.frame(in: .scrollView(axis: .vertical))
            let minY = rect.minY
            let topValue: CGFloat = 75.0
            let offset = min(minY - 75, 0)
            let progress = max(min(-offset / topValue, 1), 0)
            let scale: CGFloat = 1 + progress
            
            ZStack {
                Rectangle()
                    .fill(card.bgColor)
                    .overlay(alignment: .leading) {
                        Circle()
                            .fill(card.bgColor)
                            .overlay {
                                Circle()
                                    .fill(.white.opacity(0.2))
                            }
                            .scaleEffect(2, anchor: .topLeading)
                            .offset(x: -50, y: -40)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .scaleEffect(scale, anchor: .bottom)
                    
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer(minLength: 0)
                    
                    Text("Current Balance")
                        .font(.callout)
                    
                    Text(card.balance)
                        .font(.title.bold())
                    
                } //: VSTACK BALANCE
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15)
                .offset(y: progress * -25)
                
            } //: ZSTACK
            .offset(y: -offset)
            /// Moving till top value
            .offset(y: progress * -topValue)
            
            
        } //: GEOMETRY
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func ExpenseCardView(_ expense: Expense) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.product)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text(expense.spendType)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
            } //: VSTACK
            
            Spacer(minLength: 0)
            
            Text(expense.amountSpent)
                .fontWeight(.bold)
            
        } //: HSTACK
        .padding(.horizontal, 15)
        .padding(.vertical, 6)
    }
    
    @ViewBuilder
    func MaskingRectangle(cornerRadiusMultiplier: CGFloat = 1) -> some View {
        RoundedRectangle(cornerRadius: 30 * cornerRadiusMultiplier, style: .continuous)
            .fill(scheme == .dark ? .black : .white)
            /// Limiting backgroiund scroll below the header
            .visualEffect { content, proxy in
                content
                    .offset(y: backgroundLimitOffset(proxy))
            }
    }
    
}

// Custom scroll target behaviour
// ScrollWillEndDragging in UIKit
struct CustomScrollBehaviour: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 75 {
            target.rect = .zero
        }
    }
}


// MARK: - PREVIEW
#Preview(traits: .sizeThatFitsLayout) {
    Home()
}
