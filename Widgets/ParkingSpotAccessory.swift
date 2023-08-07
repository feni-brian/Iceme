//
//  ParkingSpotAccessory.swift
//  WidgetsExtension
//
//  Created by Feni Brian on 07/08/2023.
//

import SwiftUI
import WidgetKit
import FoodTruckKit

struct ParkingSpotAccessory: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Parking Spot", provider: Provider()) { entry in
            ParkingSpotAccessoryView(entry: entry)
        }
        .supportedFamilies(ParkingSpotAccessory.supportedFamilies)
        .configurationDisplayName("Parking Spot")
        .description("Information about your Corner Iceme's Food Truck parking spot.")
    }
    
    static var supportedFamilies: [WidgetFamily] {
        var families: [WidgetFamily] = []
        
        #if os(iOS) || os(watchOS)
        // Common families between iOS and watchOS
        families += [.accessoryRectangular, .accessoryCircular, .accessoryInline]
        #endif
        #if os(iOS)
        // Families specific to iOS
        families += [.systemSmall]
        #endif
        
        return families
    }
    
    struct Provider: TimelineProvider {
        func placeholder(in context: Context) -> Entry { Entry.preview }
        
        func getSnapshot(in context: Context, completion: @escaping (ParkingSpotAccessory.Entry) -> Void) { completion(.preview) }
        
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            let timeline = Timeline(entries: [Entry.preview], policy: .never)
            completion(timeline)
        }
    }
    
    struct Entry: TimelineEntry {
        var date: Date
        var city: City
        var parkingSpot: ParkingSpot
        
        static let preview = Entry(date: .now, city: .cupertino, parkingSpot: City.cupertino.parkingSpots[0])
    }
}

struct ParkingSpotAccessoryView: View {
    var entry: ParkingSpotAccessory.Entry
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        switch family {
        #if os(iOS) || os(watchOS)
        case .accessoryInline : Label(entry.parkingSpot.name, systemImage: "box.truck")
        case .accessoryCircular:
            VStack {
                Image(systemName: "box.truck")
                Text("CUP")
            }
        case .accessoryRectangular:
            Label {
                Text("Parking Spot")
                Text(entry.parkingSpot.name)
                Text(entry.city.name)
            } icon: { Image(systemName: "box.truck") }
        #endif
        default: Text("Unsupported")
        }
    }
}

struct ParkingSpotAccessory_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ParkingSpotAccessory.supportedFamilies, id: \.rawValue) { family in
            ParkingSpotAccessoryView(entry: .preview)
                .previewContext(WidgetPreviewContext(family: family))
                .previewDisplayName("Parking Spot: \(family)")
        }
    }
}
