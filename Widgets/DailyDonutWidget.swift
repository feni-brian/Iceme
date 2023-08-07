//
//  DailyDonutWidget.swift
//  WidgetsExtension
//
//  Created by Feni Brian on 07/08/2023.
//

import SwiftUI
import WidgetKit
import FoodTruckKit

struct DailyDonutWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Daily Donut", provider: Provider()) { entry in
            DailyDonutWidgetView(entry: entry)
        }
        .supportedFamilies(DailyDonutWidget.supportedFamilies)
        .configurationDisplayName("Daily Donut")
        .description("Showcasing the latest trending donuts.")
    }
    
    struct Entry: TimelineEntry {
        var date: Date
        var donut: Donut
        
        static let preview = Entry(date: .now, donut: .preview)
    }
    
    struct Provider: TimelineProvider {
        func placeholder(in context: Context) -> DailyDonutWidget.Entry { Entry.preview }
        
        func getSnapshot(in context: Context, completion: @escaping (DailyDonutWidget.Entry) -> Void) { completion(.preview) }
        
        func getTimeline(in context: Context, completion: @escaping (Timeline<DailyDonutWidget.Entry>) -> Void) {
            var entries: [Entry] = []
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = Entry(date: entryDate, donut: Donut.all[hourOffset % Donut.all.count])
                entries.append(entry)
            }
            let timeline = Timeline<DailyDonutWidget.Entry>(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    static var supportedFamilies: [WidgetFamily] {
        var families: [WidgetFamily] = []
        
        #if os(iOS) || os(macOS)
        // Common families between iOS and macOS
        families += [.systemSmall, .systemMedium, .systemLarge]
        #endif
        
        #if os(iOS)
        // Families specific to iOS
        families += [.systemExtraLarge]
        #endif
        
        return families
    }
}

struct DailyDonutWidgetView: View {
    var entry: DailyDonutWidget.Entry
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                DonutView(donut: entry.donut)
                Text(entry.donut.name)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.indigo.gradient)
        case .systemMedium:
            HStack {
                VStack {
                    DonutView(donut: entry.donut)
                    Text(entry.donut.name)
                }
                Text("Trend Data...")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.indigo.gradient)
        case .systemLarge:
            HStack {
                VStack {
                    DonutView(donut: entry.donut)
                    Text(entry.donut.name)
                }
                Text("Trend Data...")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.indigo.gradient)
        case .systemExtraLarge:
            HStack {
                VStack {
                    DonutView(donut: entry.donut)
                    Text(entry.donut.name)
                }
                Text("Trend Data...")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.indigo.gradient)
        default:
            Text("Unsupported!")
        }
    }
}

struct DailyDonutWidget_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(DailyDonutWidget.supportedFamilies, id: \.rawValue) { family in
            DailyDonutWidgetView(entry: .preview)
                .previewContext(WidgetPreviewContext(family: family))
                .previewDisplayName("Daily Donut: \(family)")
        }
    }
}
