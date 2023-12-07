//
//  GroupedExpense.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import Foundation

struct GroupedExpense: Identifiable {
    
    var id = UUID()
    var date: Date
    var expenses: [Expense]
    
    /// Group Title
    var groupTitle: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
}
