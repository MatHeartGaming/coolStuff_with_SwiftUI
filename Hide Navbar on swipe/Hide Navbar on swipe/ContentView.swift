//
//  ContentView.swift
//  Hide Navbar on swipe
//
//  Created by Matteo Buompastore on 10/01/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - UI
    @State private var hideNavBar = false
    
    var body: some View {
        NavigationStack {
            
            List {
                GenerateItems { index in
                    NavigationLink {
                        List {
                            GenerateItems(for: 100) { index in
                                Text("List item \(index)")
                            }
                        } //: LIST
                        .navigationTitle("Item \(index)")
                        .hideNavigationBarOnSwipe(false)
                    } label: {
                        Text("List item \(index)")
                    } //: NAVIGATION LINK
                }
            } //: LIST
            .listStyle(.plain)
            .navigationTitle("Chat App")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        hideNavBar.toggle()
                    }, label: {
                        Image(systemName: hideNavBar ? "eye.slash" : "eye")
                    })
                }
            }
            .hideNavigationBarOnSwipe(hideNavBar)
            
        } //: NAVGATION
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    func GenerateItems<Content: View>(for times: Int = 50, @ViewBuilder content: @escaping (Int) -> Content) -> some View {
        ForEach(1...times, id: \.self) { index in
            content(index)
        } //: LOOP
    }
    
}

#Preview {
    ContentView()
}
