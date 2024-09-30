//
//  Note.swift
//  Notes App
//
//  Created by Matteo Buompastore on 30/09/24.
//

import SwiftUI
import SwiftData

@Model
class Note {
    
    init(colorString: String, title: String, content: String) {
        self.colorString = colorString
        self.title = title
        self.content = content
    }
    
    var id: String = UUID().uuidString
    var dateCreated: Date = Date()
    var colorString: String
    var title: String
    var content: String
    
    /// View
    var allowsHitTesting: Bool = false
    
    var color: Color {
        Color(colorString)
    }
    
    var isEmpty: Bool {
        title.isEmpty && content.isEmpty
    }
    
}

/*
var mockNotes: [Note] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .purple),
]
*/
