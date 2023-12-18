//
//  Transactions+Extensions.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 18/12/23.
//

import Foundation

extension [Transaction] {
    
    func sum() -> Double {
        return self.reduce(0) { partialResult, transaction in
            partialResult + transaction.amount
        }
    }
    
    func filterBy(category: Category) -> [Transaction] {
        self.filter({ $0.category == category.rawValue })
    }
    
}
