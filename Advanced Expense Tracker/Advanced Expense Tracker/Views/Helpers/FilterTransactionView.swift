//
//  FilterTransactionView.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 18/12/23.
//

import SwiftUI
import SwiftData

struct FilterTransactionView<Content: View>: View {
    
    var content: ([Transaction]) -> Content
    
    @Query(animation: .snappy) private var transactions: [Transaction]
    
    init(category: Category?, searchText: String, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        /// Custom Predicate
        let rawValue = category?.rawValue ?? ""
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.title.localizedStandardContains(searchText) ||
            transaction.remarks.localizedStandardContains(searchText)) && (rawValue.isEmpty ? true : transaction.category == rawValue)
        }
        
        _transactions = Query(filter: predicate, sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)], animation: .snappy)
        self.content = content
    }
    
    init(startDate: Date, endDate: Date, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        /// Custom Predicate
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.dateAdded >= startDate && transaction.dateAdded <= endDate)
        }
        
        _transactions = Query(filter: predicate, sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)], animation: .snappy)
        self.content = content
    }
    
    /// Optional for your cusomized use
    init(startDate: Date, endDate: Date, category: Category?, searchText: String? = nil, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        /// Custom Predicate
        let rawValue = category?.rawValue ?? ""
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.dateAdded >= startDate && transaction.dateAdded <= endDate) && (rawValue.isEmpty ? true : transaction.category == rawValue)
        }
        
        _transactions = Query(filter: predicate, sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)], animation: .snappy)
        self.content = content
    }
    
    var body: some View {
        content(transactions)
    }
    
}
