//
//  Home.swift
//  Minimal SwiftData Todo List
//
//  Created by Matteo Buompastore on 01/02/24.
//

import SwiftUI
import SwiftData

struct Home: View {
    
    //MARK: - Properties
    @Query(filter: #Predicate<Todo> { !$0.isCompleted },
           sort: [SortDescriptor(\Todo.lastUpdated, order: .reverse)],
           animation: .snappy) private var activeList: [Todo]
    /// Model Context
    @Environment(\.modelContext) private var context
    @State private var showAll = false
    
    var body: some View {
        List {
            Section(activeSectionTitle) {
                ForEach(activeList) { todo in
                    TodoRow(todo: todo)
                }
            } //: SECTION
            
            /// Completed List
            CompletedTodoList(showAll: $showAll)
            
        } //: LIST
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    /// Creating an Empty Task
                    let todo = Todo(task: "", priority: .normal)
                    /// Saving into context
                    context.insert(todo)
                    
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 42))
                })
            }
        } //: Toolbar
    }
    
    
    //MARK: - Computed Properties
    
    var activeSectionTitle: String {
        let count = activeList.count
        return count == 0 ? "Active" : "Active \(count)"
    }
    
}

#Preview {
    ContentView()
}

#Preview {
    Home()
}
