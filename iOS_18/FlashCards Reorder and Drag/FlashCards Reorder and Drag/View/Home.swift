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
    @EnvironmentObject private var properties: DragProperties
    
    /// Scroll Properties
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = 0
    @State private var dragScrollOffset: CGFloat = 0
    @GestureState private var isActive: Bool = false
    
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
        } //: Toolbar
        .scrollPosition($scrollPosition)
        .onScrollGeometryChange(for: CGFloat.self, of: {
            $0.contentOffset.y + $0.contentInsets.top
        }, action: { oldValue, newValue in
            currentScrollOffset = newValue
        })
        .allowsHitTesting(!properties.show)
        .contentShape(.rect)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($isActive, body: { _, out, _ in
                    out = true
                })
                .onChanged { value in
                    if dragScrollOffset == 0 {
                        dragScrollOffset = currentScrollOffset
                    }
                    scrollPosition.scrollTo(y: dragScrollOffset + (-value.translation.height))
                },
            /// Only enabled when drag preview is active
            isEnabled: properties.show
        )
        .onChange(of: isActive) { oldValue, newValue in
            /// Reset when gesture ends
            if !newValue {
                dragScrollOffset = 0
            }
        }
    }
}

#Preview {
    Home()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(DragProperties())
}

#Preview("Content View") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(DragProperties())
}
