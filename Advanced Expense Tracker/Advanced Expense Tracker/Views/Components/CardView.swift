//
//  CardView.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 12/12/23.
//

import SwiftUI

struct CardView: View {
    
    var income: Double
    var expense: Double
    
    var body: some View {
        
        let bankRupt: Bool = expense > income
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    
                    Text("\(currencyString(income - expense))")
                        .font(.title.bold())
                    
                    Image(systemName: bankRupt ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.title3)
                        .foregroundColor(bankRupt ? .red : .green)
                    
                } //: HSTACK
                .padding(.bottom, 25)
                
                HStack(spacing: 0) {
                    ForEach(Category.allCases, id: \.self) { category in
                        let isIncomeCategory = category == .income
                        let symbolImage = isIncomeCategory ? "arrow.down" : "arrow.up"
                        let tint: Color = isIncomeCategory ? .green : .red
                        
                        HStack(spacing: 10) {
                            Image(systemName: symbolImage)
                                .font(.callout.bold())
                                .foregroundStyle(tint)
                                .frame(width: 35, height: 35)
                                .background(
                                    Circle()
                                        .fill(tint.opacity(0.25).gradient)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text(category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                Text(currencyString(isIncomeCategory ? income : expense, allowDigits: 0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                
                            } //: VSTACK
                            
                            if isIncomeCategory {
                                Spacer(minLength: 10)
                            }
                            
                        } //: HSTACK
                        
                    } //: LOOP CATEGORIES
                } //: HSTACK CATEGORIES
                
            } //: VSTACK
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 15)
            
        } //: ZSTACK
    }
}

#Preview {
    ScrollView(.vertical) {
        CardView(income: 2000, expense: 1200)
    }
}
