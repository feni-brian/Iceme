//
//  WidgetColours.swift
//  WidgetsExtension
//
//  Created by Feni Brian on 07/08/2023.
//

import SwiftUI

extension Color {
    static let widgetAccent = Color("AccentColor")
    static let widgetAccentDimmed = Color("AccentColorDimmed")
}

extension Gradient {
    static let widgetAccent = Gradient(colors: [.widgetAccentDimmed, .widgetAccent])
}
