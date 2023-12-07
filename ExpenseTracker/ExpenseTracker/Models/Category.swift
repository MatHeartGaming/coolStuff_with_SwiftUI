//
//  Category.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import Foundation
import SwiftData

@Model
class Category {
    
    var categoryName: String
    /// Category Expanses
    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expanses: [Expense]?
    
    init(categoryName: String) {
        self.categoryName = categoryName
    }
}
