//
//  ChartModel.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 21/12/23.
//

import SwiftUI

struct ChartGroup: Identifiable {
    
    let id = UUID()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Double
    var totalExpense: Double
    
}

struct ChartCategory: Identifiable {
    
    let id = UUID()
    var totalValue: Double
    var category: Category
    
}
