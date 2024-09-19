//
//  ContentView.swift
//  Import Export SwiftData With Pwd
//
//  Created by Matteo Buompastore on 19/09/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // MARK: Properties
    @Query(sort: [.init(\Transaction.transactionDate, order: .reverse)], animation: .snappy) private var transactions: [Transaction]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(transactions) {
                    Text($0.transactionName)
                }
            } //: LIST
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                } //: Item Trailing
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                } //: Item Trailing
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        /// Dummy Data
                        let tranaction = generateRandomTransaction()
                        context.insert(tranaction)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                } //: Item Leading
            }
        } //: NAVIGATION
    }
    
    
    // MARK: Functions
    
    private func generateRandomTransaction() -> Transaction {
            let names = ["Grocery", "Rent", "Electric Bill", "Salary", "Investment"]
            let randomName = names.randomElement() ?? "Random Transaction"
            
            // Randomize transaction amount between $10.00 and $5000.00
            let randomAmount = Double.random(in: 10...5000)
            
            // Randomize transaction date in the last 30 days
            let randomDate = Calendar.current.date(byAdding: .day, value: Int.random(in: -30...0), to: Date()) ?? Date()
            
            // Randomize transaction category
            let randomCategory: TransactionCategory = Bool.random() ? .income : .expense
            
            return Transaction(transactionName: randomName, transactionDate: randomDate, transactionAmount: randomAmount, transactionCategory: randomCategory)
        }
    
}

/// Swift Data Model
@Model
class Transaction: Codable {
    var transactionName: String
    var transactionDate: Date
    var transactionAmount: Double
    var transactionCategory: TransactionCategory
    
    init(transactionName: String, transactionDate: Date, transactionAmount: Double, transactionCategory: TransactionCategory) {
        self.transactionName = transactionName
        self.transactionDate = transactionDate
        self.transactionAmount = transactionAmount
        self.transactionCategory = transactionCategory
    }
    
    init(transactionName: String, transactionDate: Date, transactionAmount: String, transactionCategory: TransactionCategory) {
        self.transactionName = transactionName
        self.transactionDate = transactionDate
        self.transactionAmount = Double(transactionAmount) ?? 0
        self.transactionCategory = transactionCategory
    }
    
    enum CodingKeys: CodingKey {
        case transactionName
        case transactionDate
        case transactionAmount
        case transactionCategory
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transactionName = try container.decode(String.self, forKey: .transactionName)
        transactionDate = try container.decode(Date.self, forKey: .transactionDate)
        transactionAmount = try container.decode(Double.self, forKey: .transactionAmount)
        transactionCategory = try container.decode(TransactionCategory.self, forKey: .transactionCategory)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transactionName, forKey: .transactionName)
        try container.encode(transactionDate, forKey: .transactionDate)
        try container.encode(transactionAmount, forKey: .transactionAmount)
        try container.encode(transactionCategory, forKey: .transactionCategory)
    }
    
}

enum TransactionCategory: String, Codable {
    case income = "Income"
    case expense = "Expense"
}

#Preview {
    ContentView()
        .modelContainer(for: Transaction.self)
}
