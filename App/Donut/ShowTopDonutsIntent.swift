//
//  ShowTopDonutsIntent.swift
//  Iceme Corner
//
//  Created by Feni Brian on 22/07/2023.
//

import SwiftUI
import AppIntents
import FoodTruckKit

struct ShowTopDonutsIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Top Donuts"
    
    @Parameter(title: "Timeframe")
    var timeframe: Timeframe
    
    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        .result(view: ShowTopDonutsIntentView(timeframe: timeframe))
    }
}

struct FoodTruckShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: ShowTopDonutsIntent(), phrases: ["\(.applicationName) Trends for \(\.$timeframe)"])
    }
}

extension Timeframe: AppEnum {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Timeframe"
    
    public static var caseDisplayRepresentations: [Timeframe : DisplayRepresentation] = [
        .today: "Today",
        .week: "This Week",
        .month: "This Month",
        .year: "This Year"
    ]
}

extension ShowTopDonutsIntent {
    init(timeframe: Timeframe) {
        self.timeframe = timeframe
    }
}
