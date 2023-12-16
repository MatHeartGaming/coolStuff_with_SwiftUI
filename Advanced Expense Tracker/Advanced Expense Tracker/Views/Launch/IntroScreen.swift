//
//  IntroScreen.swift
//  Advanced Expense Tracker
//
//  Created by Matteo Buompastore on 11/12/23.
//

import SwiftUI

struct IntroScreen: View {
    
    // MARK: - UI
    @AppStorage("isFirstTime") private var isFirstTime = true
    
    var body: some View {
        VStack(spacing: 15) {
            
            Text("What's new in the Expense Tracker?")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            /// Points View
            VStack(alignment: .leading, spacing: 25) {
                
                PointView(symbol: "dollarsign", title: "Transactions", subTitle: "Keep track of your earnings and expenses.")
                
                PointView(symbol: "chart.bar.fill", title: "Visual Charts", subTitle: "View your transactions using eye-catching graphic representations.")
                
                PointView(symbol: "magnifyingglass", title: "Advanced Filters", subTitle: "Find the expense you want using the advanced search and filtering engine.")
                
            } //: Point View VSTACK
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 25)
            
            Spacer(minLength: 10)
            
            Button(action: {
                isFirstTime = false
            }, label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(appTint.gradient, in: .rect(cornerRadius: 12, style: .continuous))
                    .contentShape(.rect)
            }) //: CONTINUE BUTTON
            .padding(15)
            
        } //: VSTACK
    }
    
    
    //MARK: - Other Views
    
    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(spacing: 15) {
            
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .foregroundStyle(.gray)
                
            } //: VSTACK
            
        } //: HSTACK
    }
    
}

#Preview {
    IntroScreen()
}
