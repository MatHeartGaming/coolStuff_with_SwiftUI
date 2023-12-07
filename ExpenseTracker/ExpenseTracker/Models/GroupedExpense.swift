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
    
}
