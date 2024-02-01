//
//  TodoRow.swift
//  Minimal SwiftData Todo List
//
//  Created by Matteo Buompastore on 01/02/24.
//

import SwiftUI
import WidgetKit

struct TodoRow: View {
    
    //MARK: - Properties
    @Bindable var todo: Todo
    
    /// UI
    @FocusState private var isKeyboardActive: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    
    var body: some View {
        HStack(spacing: 8) {
            if !isKeyboardActive && !todo.task.isEmpty {
                Button(action: {
                    todo.isCompleted.toggle()
                    todo.lastUpdated = .now
                    WidgetCenter.shared.reloadAllTimelines()
                }, label: {
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.isCompleted ? .gray : .accentColor)
                        .contentTransition(.symbolEffect(.replace))
                }) //: Button Checkmark
            }
            
            TextField("Win RE4", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
                .focused($isKeyboardActive)
            
            if !isKeyboardActive && !todo.task.isEmpty {
                /// Priority Menu Button
                Menu {
                    ForEach(Priority.allCases, id: \.rawValue) { priority in
                        Button(action: {
                            withAnimation {
                                todo.priority = priority
                            }
                        }, label: {
                            HStack {
                                Text(priority.rawValue)
                                
                                if todo.priority == priority {
                                    Image(systemName: "checkmark")
                                }
                            } //: HSTACK
                        }) //: BUTTON Priority
                    } //: Loop Priorities
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.priority.color)
                }
            }
            
            
        } //: HSTACK
        .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isKeyboardActive)
        .onAppear {
            isKeyboardActive = todo.task.isEmpty
            
        }
        /// Swipe to delete
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("", systemImage: "trash") {
                deleteCurrentTask()
                WidgetCenter.shared.reloadAllTimelines()
            }
            .tint(.red)
        }
        .onSubmit(of: .text) {
            if todo.task.isEmpty {
               deleteCurrentTask()
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && todo.task.isEmpty {
                deleteCurrentTask()
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
        .task {
            //MARK: - Force update of widget if a todo is edited inside the app!!
            todo.isCompleted = todo.isCompleted
        }
    }
    
    
    //MARK: - Functions
    
    private func deleteCurrentTask() {
        /// Deleting empty task
        context.delete(todo)
    }
    
}

#Preview {
    TodoRow(todo: Todo(task: "Task", isCompleted: false, priority: .medium))
}
