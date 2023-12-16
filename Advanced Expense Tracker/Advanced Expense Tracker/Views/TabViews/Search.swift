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
    private let searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationStack {
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    
                    
                    
                } //: LAZY VSTACK
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
            
        } //: NAVIGATION
    }
}

#Preview {
    Search()
}
