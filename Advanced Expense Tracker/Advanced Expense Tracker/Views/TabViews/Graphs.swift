//
//  Graphs.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI
import Charts
import SwiftData

struct Graphs: View {
    
    // MARK: - UI
    @Query(animation: .snappy) private var transactions: [Transaction]
    //var transactions: [Transaction]
    @State private var chartGroups = [ChartGroup]()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    
                    ChartView()
                        .frame(height: 200)
                        .padding(10)
                        .padding(.top, 10)
                        .background(.background, in: .rect(cornerRadius: 10))
                    
                    ForEach(chartGroups) { group in
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text(format(date: group.date, format: "MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)
                            NavigationLink {
                                ListOfTransactions(month: group.date)
                            } label: {
                                CardView(income: group.totalIncome, expense: group.totalExpense)
                            }
                            .buttonStyle(.plain)
                            
                        } //: VSTACK
                    } //: LOOP GROUPS
                    
                    
                } //: LAZY VSTACK
                .padding(15)
            } //: SCROLL
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
            .onAppear {
                /// Creating chart group
                createChartGroup()
            }
        }
    }
    
    
    // MARK: - VIEWS
    @ViewBuilder
    func ChartView() -> some View {
        Chart {
            ForEach(chartGroups) { group in
                ForEach(group.categories) { chart in
                    
                    BarMark(
                        x: .value("Month", format(date: group.date, format: "MMM yy")),
                        y: .value(chart.category.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))
                    
                } //: LOOP CATEGORIES
            } //: LOOP GROUPS
        } //: CHART
        /// Masking Chart Scrollable
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? .zero
                
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text("\(axisLabel(doubleValue))")
                }
            }
        }
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }
    
    
    // MARK: - FUNCTIONS
    private func createChartGroup() {
        Task.detached(priority: .high) {
            let calendar = Calendar.current
            let groupedByDate = Dictionary(grouping: transactions) { transaction in
                let components = calendar.dateComponents([.month, .year], from: transaction.dateAdded)
                return components
            }
            
            /// Sorting groups by date
            let sortedGroups = groupedByDate.sorted {
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup in
                let date = calendar.date(from: dict.key) ?? .init()
                let income = dict.value.filter({ $0.category == Category.income.rawValue })
                let expense = dict.value.filter({ $0.category == Category.expense.rawValue })
                
                let incomeTotalValue = total(income, category: .income)
                let expenseTotalValue = total(expense, category: .expense)
                
                return .init(
                    date: date, categories: [
                        .init(totalValue: incomeTotalValue, category: .income),
                        .init(totalValue: expenseTotalValue, category: .expense),
                    ],
                    totalIncome: incomeTotalValue,
                    totalExpense: expenseTotalValue
                )
            }
            
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
    }
    
    private func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = intValue / 1000
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
    
}


/// List of Transactions for the selected month
struct ListOfTransactions: View {
    
    let month: Date
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                
                Section {
                    FilterTransactionView(startDate: month.startOfMonth,
                                          endDate: month.endOfMonth,
                                          category: .income) { transactions in
                        
                        ForEach(transactions) { transaction in
                            NavigationLink{
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                } header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                } //: SECTION INCOME
                
                
                Section {
                    FilterTransactionView(startDate: month.startOfMonth,
                                          endDate: month.endOfMonth,
                                          category: .expense) { transactions in
                        
                        ForEach(transactions) { transaction in
                            NavigationLink{
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                } header: {
                    Text("Expense")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                } //: SECTION EXPENSES
                
            } //: LAZY VSTACK
            .padding(15)
        } //: SCROLL
        .background(.gray.opacity(0.15))
        .navigationTitle(format(date: month, format: "MMM yy"))
        /*.navigationDestination(for: Transaction.self) { transaction in
            TransactionView(editTransaction: transaction)
        }*/
    }
    
}

#Preview {
    Graphs()
        .modelContainer(for: [Transaction.self])
}
