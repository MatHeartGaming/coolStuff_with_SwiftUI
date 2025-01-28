//
//  CustomDisclosureGroup.swift
//  FlashCards Reorder and Drag
//
//  Created by Matteo Buompastore on 28/01/25.
//

import SwiftUI

struct CustomDisclosureGroup: View {
    
    // MARK: Properties
    var category: Category
    
    init(category: Category) {
        self.category = category
        
        let descriptors = [NSSortDescriptor(keyPath: \FlashCard.order, ascending: true)]
        let predicate = NSPredicate(format: "category == %@", category)
        _cards = .init(entity: FlashCard.entity(),
                       sortDescriptors: descriptors, predicate: predicate, animation: .easeInOut(duration: 0.15))
    }
    
    @FetchRequest private var cards: FetchedResults<FlashCard>
    
    /// UI
    @State private var isExpanded: Bool = true /// Starts open
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                Text(category.title ?? "New Folder")
                
                Spacer(minLength: 0)
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 0 : 180))
                
            } //: HSTACK
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundStyle(.blue)
            
            if isExpanded {
                CardsView()
                    .transition(.blurReplace)
            }
            
        } //: VSTACK
        .padding(15)
        .padding(.vertical, isExpanded ? 0 : 5)
        .background(.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy) {
                isExpanded.toggle()
            }
        }
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func CardsView() -> some View {
        if cards.isEmpty {
            Text("No Flashcards have been added to this folder yet.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
                .padding(.vertical, 10)
        } else {
            ForEach(cards) { card in
                FlashCardView(card: card, categpry: category)
            }
        }
    }
    
}

#Preview {
    CustomDisclosureGroup(category: Category())
}

#Preview("Content View") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
