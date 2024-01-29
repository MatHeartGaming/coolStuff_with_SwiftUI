//
//  Home.swift
//  ExpenseTracker Animation Challenge
//
//  Created by Matteo Buompastore on 29/01/24.
//

import SwiftUI

struct Home: View {
    
    //MARK: - Properties
    @State private var progress: CGFloat = 0.5
    
    /// Current Month
    @State private var currentMonth = "Jan"
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 15) {
            
            HStack {
                
                Button(action: {}, label: {
                    Image(systemName: "arrow.left")
                        .frame(width: 40, height: 40)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(.gray.opacity(0.4), lineWidth: 1)
                        }
                }) //: Back Button
                
                Spacer()
                
                Button(action: {}, label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .rotationEffect(.degrees(-90))
                }) //: Options Button
                
            } //: HSTACK Buttons
            .foregroundStyle(.white)
            .padding(.horizontal)
            
            /// Custom Gradient Card
            VStack {
                Text("Saved this Month")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.7))
                
                AnimatedText(value: progress * 1460, 
                             font: .system(size: 35, weight: .black),
                             isCurrency: true)
                    .font(.system(size: 35, weight: .black))
                    .foregroundStyle(Color("Green"))
                    .padding(.top, 5)
                    .lineLimit(1)
                
                /// Speedometer
                Speedometer(progress: $progress)
                
            } //: VSTACK
            .padding(.top, 50)
            .frame(maxWidth: .infinity)
            .frame(height: 340)
            .background {
                RoundedRectangle(cornerRadius: 45, style: .continuous)
                    .fill(
                        .linearGradient(colors: [
                            .lightGreen.opacity(0.4),
                            .lightGreen.opacity(0.2),
                            .lightGreen.opacity(0.1),
                        ] + Array(repeating: Color.clear, count: 5),
                                        startPoint: .topTrailing,
                                        endPoint: .bottomLeading)
                    )
            }
            .padding(.top, 15)
            .padding(.horizontal, 15)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(months, id: \.self) { month in
                                Text(month)
                                    .font(.callout)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 15)
                                    .background {
                                        if currentMonth == month {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "MONTH", in: animation)
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0)) {
                                            currentMonth = month
                                            progress = CGFloat.random(in: 0.1...1)
                                            //progress = progressArray[getIndex(month: month)]
                                        }
                                    }
                            } //: LOOP Months
                        } //: HSTACK
                    } //: H-SCROLL Months
                    
                    BottomContent()
                        .padding(.top, 15)
                    
                } //: VSTACK
                .padding()
            } //: SCROLL
            .padding(.top, 30)
            
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 15)
        .background {
            Color.BG
                .ignoresSafeArea()
        }
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func BottomContent() -> some View {
        VStack(spacing: 15) {
            ForEach(expenses) { expense in
                HStack(spacing: 12) {
                    Image(expense.icon)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(.white)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(expense.title)
                            .fontWeight(.bold)
                        
                        Text(expense.subtitle)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    } //: VSTACK
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(expense.amount)
                        .fontWeight(.bold)
                } //: HSTACK
                .padding()
            } // LOOP
        } //: VSTACK
    }
    
    
    //MARK: - Functions
    
    private func getIndex(month: String) -> Int {
        return months.firstIndex(where: { $0 == month }) ?? 0
    }
    
}

#Preview {
    Home()
        .preferredColorScheme(.dark)
}
