//
//  ExpenseCardView.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI

struct ExpenseCardView: View {
    
    @Bindable var expense: Expense
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Text(expense.title)
                
                Text(expense.subtitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
            } //: VSTACK
            .lineLimit(1)
            
            Spacer(minLength: 5)
            
            /// Currency String
            Text(expense.currentString)
                .font(.title3.bold())
            
        } //: HSTACK
    }
}

#Preview {
    ExpenseCardView(expense: .init(title: "Title", subtitle: "Subtitle", amount: 10.0, date: .now))
}
