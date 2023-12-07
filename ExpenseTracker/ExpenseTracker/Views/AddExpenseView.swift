//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    
    //MARK: - PROPERTIES
    
    /// - Environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    /// - UI
    @State private var title = ""
    @State private var subTitle = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?
    
    @Query(animation: .snappy) private var allCategories: [Category]
    
    
    var body: some View {
        NavigationStack {
            List {
                
                Section("Title") {
                    TextField("Magic Keyboard", text: $title)
                } //: SECTION TITLE
                
                Section("Description") {
                    TextField("Bought a keyboard at the Apple Store", text: $subTitle)
                } //: SECTION TITLE
                
                Section("Amount") {
                    HStack(spacing: 4) {
                        Text("€")
                            .fontWeight(.semibold)
                        TextField("0.0", value: $amount, formatter: formatter)
                            .keyboardType(.numberPad)
                    }
                } //: SECTION TITLE
                
                Section("Date") {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                } //: SECTION DATE
                
                /// Category Picker
                if !allCategories.isEmpty {
                    HStack {
                        Text("Category")
                        
                        Spacer()
                        
                        Picker("", selection: $category) {
                            ForEach(allCategories) {
                                Text($0.categoryName)
                                    .tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                }
                
                
                
            } //: LIST
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                } //: TOOLBAR ITEM LEADING
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        addExpense()
                    }
                    .disabled(isAddButtonEnabled)
                } //: TOOLBAR ITEM TRAILING
                
            } //: TOOLBAR
        } //: NAVIGATION
    }
    
    
    //MARK: - FUNCTIONS
    
    /// Disabling add button, until data has been entered
    var isAddButtonEnabled: Bool {
        return title.isEmpty || subTitle.isEmpty || amount == .zero
    }
    
    func addExpense() {
        let expense = Expense(title: title, subtitle: subTitle, amount: amount, date: date, category: category)
        context.insert(expense)
        /// Close  View once thata has been added successfully.
        dismiss()
    }
    
    /// Decimal Formatter
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
}

#Preview {
    AddExpenseView()
}
