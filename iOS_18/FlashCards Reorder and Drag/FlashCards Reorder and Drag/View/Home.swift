//
//  Home.swift
//  FlashCards Reorder and Drag
//
//  Created by Matteo Buompastore on 28/01/25.
//

import SwiftUI
import CoreData

struct Home: View {
    
    // MARK: Properties
    @FetchRequest(entity: Category.entity(),
                  sortDescriptors: [.init(keyPath: \Category.dateCreated, ascending: true)]) private var categories: FetchedResults<Category>
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                ForEach(categories) { category in
                    CustomDisclosureGroup(category: category)
                }  //: Loop Categories
            } //: VSTACK
            .padding(15)
        } //: V-SCROLL
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus.circle.fill") {
                    /// Adding dummy data
                    for index in 1...5 {
                        let category = Category(context: self.context)
                        category.dateCreated = Date()
                        
                        let card = FlashCard(context: self.context)
                        card.title = "Card \(index)"
                        card.category = category
                        
                        try? context.save()
                    }
                }
            }
        }
    }
}

#Preview {
    Home()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

#Preview("Content View") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
