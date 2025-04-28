//
//  ContentView.swift
//  Animated Async Button
//
//  Created by Matteo Buompastore on 28/04/25.
//

import SwiftUI

enum TransactionState: String {
    case idle = "Click to Pay"
    case analyzing = "Analyzing Payment..."
    case processing = "Processing Payment..."
    case completed = "Payment Completed!"
    case failed = "Payment Failed!"
    
    
    var color: Color {
        switch self {
        case .idle:
            return .black
        case .analyzing:
            return .blue
        case .processing:
            return Color(red: 0.8, green: 0.35, blue: 0.2)
        case .completed:
            return .green
        case .failed:
            return .red
        }
    }
    
    var image: String? {
        switch self {
        case .idle: "apple.logo"
        case .analyzing, .processing: nil
        case .completed: "checkmark.circle.fill"
        case .failed: "xmark.circle.fill"
            
        }
    }
    
}

struct ContentView: View {
    
    // MARK: Properties
    @State private var transactionState: TransactionState = .idle
    
    var body: some View {
        NavigationStack {
            VStack {
                let config = AnimatedButton.Config(
                    title: transactionState.rawValue,
                    foregroundColor: .white,
                    background: transactionState.color,
                    symbolImage: transactionState.image
                )
                
                AnimatedButton(config: config) {
                    transactionState = .analyzing
                    try? await Task.sleep(for: .seconds(3))
                    transactionState = .processing
                    try? await Task.sleep(for: .seconds(3))
                    transactionState = .completed
                    try? await Task.sleep(for: .seconds(3))
                    transactionState = .idle
                }
            } //: VSTACK
            .navigationTitle("Animated Async Button")
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
