//
//  TestWidget.swift
//  TestWidget
//
//  Created by Matteo Buompastore on 08/01/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        /// Customise your placeholder view here
        TaskEntry(firstThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let entry = TaskEntry(firstThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let firstTasks = Array(TaskDataModel.shared.tasks.prefix(3))
        let firstEntries = [TaskEntry(firstThreeTasks: firstTasks)]
        let timeline = Timeline(entries: firstEntries, policy: .atEnd)
        completion(timeline)
    }
}

struct TaskEntry: TimelineEntry {
    let date: Date = .now
    var firstThreeTasks: [TaskModel]
}

struct TestWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Tasks")
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 6) {
                
                if entry.firstThreeTasks.isEmpty {
                    Text("No tasks found")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    /// Sorting completed to last
                    ForEach(entry.firstThreeTasks.sorted { !$0.isCompleted && $1.isCompleted }) { task in
                        HStack(spacing: 6) {
                            Button(intent: ToggleStateIntent(id: task.id), label: {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(.blue)
                            })
                            .buttonStyle(.plain)

                            
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(task.taskTitle)
                                    .textScale(.secondary)
                                    .lineLimit(1)
                                    .strikethrough(task.isCompleted, pattern: .solid, color: .primary)
                                
                                Divider()
                            } //: VSTACK
                            
                            if task.id != entry.firstThreeTasks.last?.id {
                                Spacer(minLength: 0)
                            }
                        }
                    } //: LOOP
                }
                
            } //: VSTACK
        } //: VSTACK
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct TestWidget: Widget {
    let kind: String = "TestWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TestWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TestWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Task Widget")
        .description("This is an interactive widget.")
    }
}

#Preview(as: .systemSmall) {
    TestWidget()
} timeline: {
    let firstTasks = Array(TaskDataModel.shared.tasks.prefix(3))
    TaskEntry(firstThreeTasks: firstTasks)
}
