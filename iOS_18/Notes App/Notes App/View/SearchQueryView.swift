//
//  SearchQueryView.swift
//  Notes App
//
//  Created by Matteo Buompastore on 30/09/24.
//

import SwiftUI
import SwiftData

struct SearchQueryView<Content: View>: View {
    
    init(searchText: String, content: @escaping ([Note]) -> Content) {
        self.content = content
        
        let isSearchTextEmpty: Bool = searchText.isEmpty
        
        let predicate = #Predicate<Note> {
            isSearchTextEmpty || $0.title.localizedStandardContains(searchText)
        }
        
        _notes = .init(filter: predicate, sort: [.init(\.dateCreated, order: .reverse)], animation: .snappy)
    }
    
    @ViewBuilder var content: ([Note]) -> Content
    @Query var notes: [Note]
    
    var body: some View {
        content(notes)
    }
    
}

#Preview {
    ContentView()
}
