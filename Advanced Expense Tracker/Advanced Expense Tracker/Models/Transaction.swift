//
//  Transaction+.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI
import SwiftData

@Model
class Transaction {
    
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var category: String
    var tintColor: String
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    /// Extracting Color value from tintColor String
    @Transient var color: Color {
        return tints.first(where: { $0.color == self.tintColor })?.value ?? appTint
    }
    
    @Transient var tint: TintColor? {
        return tints.first(where: { $0.color == tintColor })
    }
    
    @Transient var rawCategory: Category? {
        return Category.allCases.first(where: { category == $0.rawValue })
    }
}
