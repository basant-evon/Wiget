//
//  LockScreen.swift
//  LockScreen
//
//  Created by Kumar Basant on 22/11/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}
struct LockView:View{
    var body: some View {
        Image(systemName: "lock")
        .resizable()
        .frame(width: 30,height: 40)
    }
}
struct LockScreenEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        //Text(entry.date, style: .time)
        switch widgetFamily{
        case .systemSmall:
            LockView()
            //Text(entry.date, style: .time)
        case .systemMedium:
            LockView()
            //Text(entry.date, style: .time)
        case .systemLarge:
            LockView()
           // Text(entry.date, style: .time)
        case .accessoryRectangular:
            //Text(entry.date, style: .time)
            LockView()
        case .accessoryCircular:
            Gauge(value: 0.8) {
                //Text(entry.date, style: .time)
                LockView()
            }.gaugeStyle(.accessoryCircular)
            
        case .accessoryInline:
            //Text(entry.date, style: .time)
            LockView()
        default:
            Text(entry.date, style: .time)
        }
    }
}

@main
struct LockScreen: Widget {
    let kind: String = "LockScreen"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LockScreenEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .supportedFamilies(
                    [
                        .systemSmall,
                        .systemMedium,
                        .systemLarge,
                        .systemExtraLarge,
                        .accessoryInline,
                        .accessoryCircular,
                        .accessoryRectangular
                    ]
                )
        .description("This is an example widget.")
    }
}

struct LockScreen_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")
        
        LockScreenEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
        
        LockScreenEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
    }
}
