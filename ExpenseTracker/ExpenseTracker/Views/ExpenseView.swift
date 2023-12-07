//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {
    
    //MARK: - Grouped Expenses Properties
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse),],
           animation: .snappy) private var allExpenses: [Expense]
    @State private var groupedExpenses = [GroupedExpense]()
    @State private var addExpense: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                
            } //: LIST
            .navigationTitle("Expenses")
            .overlay {
                if allExpenses.isEmpty || groupedExpenses.isEmpty {
                    ContentUnavailableView {
                        Label("No Expenses", systemImage: "tray.fill")
                    }
                }
            }
            /// New Category Add Button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        addExpense.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    })
                } //: TOOLBAR ADD BUTTON ITEM
            } //: TOOLBAR
        } //: NAVIGATION
        .onChange(of: allExpenses, initial: true) { oldValue, newValue in
            if groupedExpenses.isEmpty {
                createGroupedExpenses(newValue)
            }
        }
        .sheet(isPresented: $addExpense, content: {
            AddExpenseView()
        })
    }
    
    //MARK: - FUNCTIONS
    
    /// Group Expenses by Date
    func createGroupedExpenses(_ expenses: [Expense]) {
        /// In order to avoid UI lags when processing large amount of data we use Detached Tasks
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) { exepnse in
                let dateComponent = Calendar.current.dateComponents([.day, .month, .year], from: exepnse.date)
                return dateComponent
            }
            
            /// Sorting Dictionary in descending order
            let sortedDict = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            /// Adding to the Grouped Expense array
            /// UI must be updated on the main thread
            await MainActor.run {
                groupedExpenses = sortedDict.compactMap({ dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                })
            }
            
        } //: TASK
    }
    
}

#Preview {
    ExpenseView()
}
