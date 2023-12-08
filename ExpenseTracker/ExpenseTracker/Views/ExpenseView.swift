//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {
    
    //MARK: - PROPERTIES
    @Binding var currentTab: String
    
    /// - Environment
    @Environment(\.modelContext) private var context
    
    //MARK: - Grouped Expenses Properties
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse),],
           animation: .snappy) private var allExpenses: [Expense]
    @State private var groupedExpenses = [GroupedExpense]()
    @State private var originalGroupedExpenses = [GroupedExpense]()
    @State private var addExpense: Bool = false
    
    /// Search Text
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($groupedExpenses) { $group in
                    Section(group.groupTitle) {
                        ForEach(group.expenses) { expense in
                            
                            /// Card View
                            ExpenseCardView(expense: expense)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    /// Delete
                                    Button {
                                        context.delete(expense)
                                        withAnimation {
                                            group.expenses.removeAll(where: { $0.id == expense.id })
                                            /// Removing group if no expenses are present
                                            if group.expenses.isEmpty {
                                                groupedExpenses.removeAll(where: { $0.id == group.id })
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    } //: DELETE BUTTON
                                    .tint(.red)
                                    
                                    
                                    
                                }
                            
                        } //: LOOP EXPENSES
                    } //: LOOP GROUPED EXPENSES
                } //: LIST
                
                
            } //: LIST
            .navigationTitle("Expenses")
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: Text("Search"))
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
            if newValue.count > oldValue.count || groupedExpenses.isEmpty || currentTab == "Categories" {
                createGroupedExpenses(newValue)
            }
        }
        .onChange(of: searchText, initial: false) { oldValue, newValue in
            if !newValue.isEmpty {
                filterExpenses(newValue)
            } else {
                self.groupedExpenses = self.originalGroupedExpenses
            }
        }
        .sheet(isPresented: $addExpense, content: {
            AddExpenseView()
                .interactiveDismissDisabled()
        })
    }
    
    //MARK: - FUNCTIONS
    
    /// Filtering Fxpenses
    func filterExpenses(_ text: String) {
        Task.detached(priority: .high) {
            let query = text.lowercased()
            let filteredExpenses = originalGroupedExpenses.compactMap { group -> GroupedExpense? in
                let expenses = group.expenses.filter({ $0.title.lowercased().contains(query) })
                if expenses.isEmpty {
                    return nil
                }
                return .init(date: group.date, expenses: expenses)
            }
            
            await MainActor.run {
                groupedExpenses = filteredExpenses
            }
        }
    }
    
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
                originalGroupedExpenses = groupedExpenses
            }
            
        } //: TASK
    }
    
}

#Preview {
    ExpenseView(currentTab: .constant("Expenses"))
}
