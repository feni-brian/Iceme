//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by Feni Brian on 17/07/2023.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        // MARK: - Accessory Widgets
        #if os(iOS) || os(watchOS)
        OrdersWidget()
        ParkingSpotAccessory()
        #endif
        
        // MARK: - Widgets
        #if os(iOS) || os(macOS)
        DailyDonutWidget()
        #endif
        
        // MARK: - Ignore Widget(unused)
        Widgets()
    }
}
