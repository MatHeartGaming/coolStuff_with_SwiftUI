//
//  CardView.swift
//  FlashCards Reorder and Drag
//
//  Created by Matteo Buompastore on 28/01/25.
//

import SwiftUI

struct FlashCardView: View {
    
    var card: FlashCard
    var categpry: Category
    
    var body: some View {
        GeometryReader {
            let rect = $0.frame(in: .global)
            
            Text(card.title ?? "")
                .padding(.horizontal, 15)
                .frame(width: rect.width, height: rect.height, alignment: .leading)
                .background()
            
        }
         //: GEOMETRY
        .frame(height: 60)
    }
}

#Preview("Content View") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
