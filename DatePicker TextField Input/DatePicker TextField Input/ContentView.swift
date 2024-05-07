//
//  ContentView.swift
//  DatePicker TextField Input
//
//  Created by Matteo Buompastore on 07/05/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State private var date: Date = .now
    
    var body: some View {
        NavigationStack {
            DateTF(date: $date) { date in
                return date.formatted()
            }
            .navigationTitle("Date Picker TextField")
        }
    }
}

#Preview {
    ContentView()
}
