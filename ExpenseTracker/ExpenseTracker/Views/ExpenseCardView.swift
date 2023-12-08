//
//  ExpenseCardView.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI

struct ExpenseCardView: View {
    
    // MARK: - UI
    @Bindable var expense: Expense
    var displayTag: Bool = true
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Text(expense.title)
                
                Text(expense.subtitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                if let categoryName = expense.category?.categoryName, displayTag {
                    Text(categoryName)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.red.gradient, in: .capsule)
                }
                
            } //: VSTACK
            .lineLimit(1)
            
            Spacer(minLength: 5)
            
            /// Currency String
            Text(expense.currentString)
                .font(.title3.bold())
            
        } //: HSTACK
    }
}
