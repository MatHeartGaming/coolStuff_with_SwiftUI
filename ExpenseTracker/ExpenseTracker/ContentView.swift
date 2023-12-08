//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - UI
    @State private var currentTab: String = "Expenses"
    
    var body: some View {
        TabView(selection: $currentTab) {
            
            ExpenseView(currentTab: $currentTab)
                .tag("Expenses")
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            
            CategoryView()
                .tag("Categories")
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Categories")
                }
            
        }
    }
}

#Preview {
    ContentView()
}
