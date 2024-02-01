//
//  TodoList.swift
//  TodoList
//
//  Created by Matteo Buompastore on 01/02/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TodoListEntryView : View {
    var entry: Provider.Entry
    /// Query that will fetch 3 active Todo at a time
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]

    var body: some View {
        VStack {
            ForEach(activeList) { todo in
                HStack(spacing: 10) {
                    /// Intent Action Button
                    Button(intent: ToggleButton(id: todo.taskID)) {
                        Image(systemName: "circle")
                    }
                    .font(.callout)
                    .tint(todo.priority.color)
                    .buttonBorderShape(.circle)
                    
                    Text(todo.task)
                        .font(.callout)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                } //: HSTACK
                .transition(.push(from: .bottom))
                
            } //: LOOP Active List
        } //: VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if activeList.isEmpty {
                Text("No Tasks 🥳")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
    
}

struct TodoList: Widget {
    let kind: String = "TodoList"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoListEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                /// SwiftData Container
                .modelContainer(for: Todo.self)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Tasks")
        .description("This is a Todo List")
    }
}


/// Button Intent
struct ToggleButton: AppIntent {
    
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggles Todo State")
    
    @Parameter(title: "Todo ID")
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    init() {
        
    }
    
    func perform() async throws -> some IntentResult {
        /// Updating todo
        let context = try ModelContext(.init(for: Todo.self))
        /// Retrieving the Todo
        let descriptor = FetchDescriptor(predicate: #Predicate<Todo> { $0.taskID == id })
        if let todo = try context.fetch(descriptor).first {
            todo.isCompleted = true
            todo.lastUpdated = .now
            /// Saving context
            try context.save()
        }
        return .result()
    }
    
}

#Preview(as: .systemSmall) {
    TodoList()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
