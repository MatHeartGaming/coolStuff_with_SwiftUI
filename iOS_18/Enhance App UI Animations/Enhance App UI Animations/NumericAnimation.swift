//
//  NumericAnimation.swift
//  Enhance App UI Animations
//
//  Created by Matteo Buompastore on 18/09/24.
//

import SwiftUI

struct NumericAnimation: View {
    
    @State private var showNumber: Bool = false
    
    var body: some View {
        HStack(spacing: 15) {
            Text(showNumber ? "1234 5678 0098 2389" : "XXXX XXXX XXXX XX89")
                .monospaced()
                .fontWeight(.semibold)
                .contentTransition(.numericText())
            
            Button {
                withAnimation(.bouncy) {
                    showNumber.toggle()
                }
            } label: {
                Image(systemName: showNumber ? "eye.slash" : "eye")
                    .foregroundStyle(.purple.gradient)
                    .contentTransition(.symbolEffect(.replace))
            }

        } //: HSTACK
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.purple.opacity(0.12).gradient)
        }
    }
}

#Preview {
    NumericAnimation()
}
