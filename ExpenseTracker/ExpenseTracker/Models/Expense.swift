//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import Foundation
import SwiftData

@Model
class Expense {
    
    var title: String
    var subtitle: String
    var amount: Double
    var date: Date
    
    /// Expense Category
    var category: Category?
    
    init(title: String, subtitle: String, amount: Double, date: Date, category: Category? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.date = date
        self.category = category
    }
    
}
