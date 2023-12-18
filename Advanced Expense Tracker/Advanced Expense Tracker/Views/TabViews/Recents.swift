//
//  Recents.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI
import SwiftData

struct Recents: View {
    
    //MARK: - PROPERTIES
    //var transactions: [Transaction] = sampleTransactions
    
    /// User
    @AppStorage("userName") private var userName = ""
    
    /// View
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var selectedCategory: Category = .expense
    @State private var showFilterView = false
    
    /// Animations
    @Namespace private var animation
    
    /// Swift Data Transacrions
    @Query(sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)], animation: .snappy) private var transactions: [Transaction]
    
    
    var body: some View {
        GeometryReader {
            /// For Animation purpose
            let size = $0.size
            
            NavigationStack {
                ScrollView(.vertical) {
                    
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        
                        Section {
                            /// Date Filter Button
                            Button(action: {
                                showFilterView = true
                            }, label: {
                                HStack(spacing: 4) {
                                    Text("\(format(date: startDate, format: "dd/MMM/yyyy")) to \(format(date: endDate, format: "dd/MMM/yyyy"))")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                    
                                    Image(systemName: "line.3.horizontal.decrease.circle")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.gray)
                                }
                            }) // FILTER BUTTON
                            .hSpacing(.leading)
                            
                            FilterTransactionView(startDate: startDate, endDate: endDate) { transactions in
                                /// Card View
                                CardView(income: sumOfIncomes, expense: sumOfExpenses)
                                
                                /// Custom Segmented Control
                                CustomSegmentedControl()
                                    .padding(.bottom, 10)
                                
                                ForEach(transactions.filterBy(category: selectedCategory)) { transaction in
                                    NavigationLink(value: transaction) {
                                        TransactionCardView(transaction: transaction)
                                    }
                                }
                            }
                            
                        } header: {
                            HeaderView(size)
                        } //: SECTION

                        
                    } //: LAZY VSTACK
                    .padding(15)
                    
                    
                } //: SCROLLVIEW
                .background(.gray.opacity(0.15))
                .blur(radius: showFilterView ? 8 : 0)
                .disabled(showFilterView)
                .navigationDestination(for: Transaction.self) { transaction in
                    TransactionView(editTransaction: transaction)
                }
                
            } //: NAVIGATION
            .overlay {
                if showFilterView {
                    DateFilterView(start: startDate, end: endDate, onSubmit: { start, end in
                        startDate = start
                        endDate = end
                        showFilterView = false
                    }, onClose: {
                        showFilterView = false
                    })
                    .transition(.move(edge: .leading))
                }
            } //: Overlay Filter View
            .animation(.snappy, value: showFilterView)
        } //: GEOMETRY
        
    }
    
    //MARK: - OTHER VIEWS
    
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                
            } //: VSTACK
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
            
            Spacer(minLength: .zero)
            
            NavigationLink {
                TransactionView()
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(appTint.gradient, in: .circle)
                    .contentShape(.circle)
            } //: NAVIGATION LINK
            
        } //: HSTACK
        .padding(.bottom, userName.isEmpty ? 10 : 5)
        .background{
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                Divider()
            }
            .visualEffect { content, geometryProxy in
                content
                    .opacity(headerBGOpacity(geometryProxy))
            }
            .padding(.horizontal, -15)
            .padding(.top, -(safeArea.top + 15))
        }
        
    }
    
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {
            
            ForEach(Category.allCases, id: \.self) { category in
                Text(category.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if category == selectedCategory {
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    } //: TEXT
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedCategory = category
                        }
                    }
            } //: LOOP
            
        } //: HSTACK
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top, 5)
    }
    
    
    //MARK: - FUNCTIONS
    private func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.6
        return 1 + scale
    }
    
    private func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY +  safeArea.top
        return minY > 0 ? .zero : (-minY / 15)
    }
    
    private var transactionsBySelectedCategory: [Transaction] {
        transactions.filter( { $0.category == selectedCategory.rawValue } )
    }
    
    private var sumOfIncomes: Double {
        transactions.filter { transaction in
            transaction.category == Category.income.rawValue
        }.sum()
    }
    
    private var sumOfExpenses: Double {
        transactions.filter { transaction in
            transaction.category == Category.expense.rawValue
        }.sum()
    }
    
}

#Preview {
    //Recents(transactions: sampleTransactions)
    Recents()
}
