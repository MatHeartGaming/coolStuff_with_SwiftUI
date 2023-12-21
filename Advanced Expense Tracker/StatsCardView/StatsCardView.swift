//
//  StatsCardView.swift
//  StatsCardView
//
//  Created by Matteo Buompastore on 21/12/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetEntry] = []
        
        entries.append(.init(date: .now))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
}

struct StatsCardViewEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        FilterTransactionView(startDate: .now.startOfMonth, endDate: .now.endOfMonth) { transactions in
            CardView(
                income: total(transactions, category: .income),
                expense: total(transactions, category: .expense))
        }
    }
}

struct StatsCardView: Widget {
    let kind: String = "StatsCardView"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                StatsCardViewEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    .modelContainer(for: [Transaction.self])
            } else {
                StatsCardViewEntryView(entry: entry)
                    .padding()
                    .background()
                    .modelContainer(for: [Transaction.self])
            }
        }
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    StatsCardView()
} timeline: {
    WidgetEntry(date: .now)
    WidgetEntry(date: .now)
}
