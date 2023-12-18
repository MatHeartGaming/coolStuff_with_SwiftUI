//
//  Search.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI
import Combine

struct Search: View {
    
    // MARK: - UI
    @State private var searchText = ""
    @State private var filterText = ""
    @State private var selectCategory: Category? = nil
    private let searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationStack {
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    
                    FilterTransactionView(category: selectCategory,
                                          searchText: searchText) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction, showsCategory: true)
                            }
                            .buttonStyle(.plain)
                        } //: LOOP
                    } //: FILTER VIEW
                    
                } //: LAZY VSTACK
                .padding(15)
            } //: SCROLL
            .overlay {
                ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                    .opacity(filterText.isEmpty ? 1 : 0)
            }
            .onChange(of: searchText, { oldValue, newValue in
                if newValue.isEmpty {
                    filterText = ""
                }
                searchPublisher.send(newValue)
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
                filterText = text
            })
            .searchable(text: $searchText)
            .navigationTitle("Search")
            .background(.gray.opacity(0.15))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarContent()
                }
            }
        } //: NAVIGATION
    }
    
    
    //MARK: - Views
    
    func ToolbarContent() -> some View {
        Menu {
            
            Button(action: {
                withAnimation(.spring) {
                    selectCategory = nil
                }
            }, label: {
                HStack {
                    Text("Both")
                    if selectCategory == nil {
                        Image(systemName: "checkmark")
                    }
                }
            })
            
            ForEach(Category.allCases, id: \.rawValue) { category in
                Button(action: {
                    withAnimation(.spring) {
                        selectCategory = category
                    }
                }, label: {
                    HStack {
                        Text(category.rawValue)
                        if selectCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                })
            } //: LOOP
            
        } label: {
            Image(systemName: "slider.vertical.3")
        }

    }
}

#Preview {
    Search()
}
