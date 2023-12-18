//
//  NewExpenseView.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 16/12/23.
//

import SwiftUI

struct TransactionView: View {
    
    /// Env
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var editTransaction: Transaction?
    
    // MARK: - UI
    @State private var title = ""
    @State private var remarks = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category: Category = .expense
    
    /// Random tint
    @State var tint: TintColor = tints.randomElement()!
    
    var body: some View {
        ScrollView(.vertical) {
            
            VStack(spacing: 15) {
                
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                /// Preview Transaction Card View
                TransactionCardView(transaction: .init(
                    title: title,
                    remarks: remarks,
                    amount: amount,
                    dateAdded: dateAdded,
                    category: category,
                    tintColor: tint))
                
                CustomSection("Title", hint: "Samsung Tab S9", value: $title)
                
                CustomSection("Remarks", hint: "Samsung Product", value: $remarks)
                
                /// Amount And cateogory
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    HStack(spacing: 15) {
                        
                        HStack(spacing: 4) {
                            Text(currencySymbol)
                                .font(.callout.bold())
                            TextField("0.0", value: $amount, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10, style: .continuous))
                        .frame(maxWidth: 130)
                        
                        /// Custom Checkbox
                        CustomCheckbox()
                        
                    } //: HSTACK
                    
                } //: VSTACK Amount and Category
                
                /// Amount And cateogory
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10, style: .continuous))
                }
                
            } //: VSTACK FIELDS
            .padding(15)
            
        } //: SCROLL
        .navigationTitle("\(editTransaction == nil ? "Add" : "Update") Transaction")
        .background(.gray.opacity(0.15))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
            }
        }
        .onAppear {
            if let editTransaction {
                /// Load all existing data from Transaction
                title = editTransaction.title
                remarks = editTransaction.remarks
                dateAdded = editTransaction.dateAdded
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
                amount = editTransaction.amount
                if let tintColor = editTransaction.tint {
                    self.tint = tintColor
                }
            }
        }
    }
    
    
    //MARK: - FUNCTIONS
    func save() {
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remarks = remarks
            editTransaction?.amount = amount
            editTransaction?.dateAdded = dateAdded
            editTransaction?.category = category.rawValue
            editTransaction?.tintColor = tint.color
            
        } else {
            /// Saving item to SwiftData
            let transaction = Transaction(title: title,
                                          remarks: remarks,
                                          amount: amount,
                                          dateAdded: dateAdded,
                                          category: category,
                                          tintColor: tint)
            
            context.insert(transaction)
        }
        
        /// Dismissing View
        dismiss()
    }
    
    
    
    
    //MARK: - VIEWS
    
    @ViewBuilder
    func CustomSection(_ title: String, hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            
            TextField(hint, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10, style: .continuous))
            
        } //: VSTACK
    }
    
    @ViewBuilder
    func CustomCheckbox() -> some View {
        HStack(spacing: 10) {
            
            ForEach(Category.allCases, id: \.rawValue) { category in
                    
                HStack(spacing: 5) {
                    
                    ZStack {
                        
                        Image(systemName: "circle")
                            .font(.title3)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                
                        }
                        
                    } //: ZSTACK
                    .foregroundStyle(appTint)
                    
                    Text(category.rawValue)
                        .font(.caption)
                    
                } //: HSTACK
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation {
                        self.category = category
                    }
                }
                
            } //: LOOP
            
        } //: HSTACK
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10, style: .continuous))
        
    }
    
    
    /// Formatter
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
}

#Preview {
    NavigationStack {
        TransactionView()
    }
}
