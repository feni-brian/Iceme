//
//  ShowTopDonutsIntentView.swift
//  Iceme Corner
//
//  Created by Feni Brian on 22/07/2023.
//

import SwiftUI
import FoodTruckKit

struct ShowTopDonutsIntentView: View {
    var timeframe: Timeframe
    @StateObject private var model = FoodTruckModel()
    
    var body: some View {
        TopFiveDonutsChart(model: model, timeframe: timeframe)
            .padding()
    }
}

struct ShowTopDonutsIntentView_Previews: PreviewProvider {
    static var previews: some View {
        ShowTopDonutsIntentView(timeframe: .week)
    }
}
