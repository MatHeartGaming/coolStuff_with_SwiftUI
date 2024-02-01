//
//  CompletedTodoList.swift
//  Minimal SwiftData Todo List
//
//  Created by Matteo Buompastore on 01/02/24.
//

import SwiftUI
import SwiftData

struct CompletedTodoList: View {
    
    //MARK: - Properties
    @Binding var showAll: Bool
    @Query private var completedList: [Todo]
    var fetchLimit: Int
    
    init(fetchLimit: Int = 15, showAll: Binding<Bool>) {
        self.fetchLimit = fetchLimit > 0 ? fetchLimit : 15
        let predicate = #Predicate<Todo> { $0.isCompleted }
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        if !showAll.wrappedValue {
            /// Limit to 15
            descriptor.fetchLimit = fetchLimit
        }
        
        _completedList = Query(descriptor, animation: .bouncy)
        self._showAll = showAll
    }
    
    var body: some View {
        Section {
            ForEach(completedList) { todo in
                TodoRow(todo: todo)
            }
        } header: {
            HStack {
                Text("Completed")
                
                Spacer(minLength: 0)
                
                if showAll && completedList.isEmpty {
                    Button("Show Recents") {
                        withAnimation(.bouncy) {
                            showAll = false
                        }
                    }
                }
            } //: HSTACK
            .font(.caption)
             
        } footer: {
            if completedList.count == fetchLimit && !showAll && !completedList.isEmpty {
                HStack {
                    Text("Showing Recent \(fetchLimit) task")
                        .foregroundStyle(.gray)
                    
                    Spacer(minLength: 0)
                    
                    Button("Show All") {
                        withAnimation(.bouncy) {
                            showAll = true
                        }
                    }
                } //: HSTACK
                .font(.caption)
            }
        } //: SECTION
    }
}

#Preview {
    CompletedTodoList(showAll: .constant(true))
}
