//
//  Expense.swift
//  ExpanseTrackerComplexScroll
//
//  Created by Matteo Buompastore on 01/12/23.
//

import Foundation

struct Expense: Identifiable {
    
    let id = UUID()
    var amountSpent: String
    var product: String
    var spendType: String
    
}
