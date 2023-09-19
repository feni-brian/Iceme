//
//  TopFiveDonutsChart.swift
//  Iceme Corner
//
//  Created by Feni Brian on 22/07/2023.
//

import SwiftUI
import FoodTruckKit

struct TopFiveDonutsChart: View {
    @ObservedObject var model: FoodTruckModel
    var timeframe: Timeframe
    var topSales: [DonutSales] { Array(model.donutSales(timeframe: timeframe).sorted().reversed().prefix(5)) }
    
    var body: some View {
        TopDonutSalesChart(sales: topSales)
            .padding()
    }
}

struct TopFiveDonutsChart_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        var timeframe: Timeframe
        var body: some View {
            TopFiveDonutsChart(model: model, timeframe: timeframe)
        }
    }
    
    static var previews: some View {
        Preview(timeframe: .today)
            .previewDisplayName("Today")
        Preview(timeframe: .week)
            .previewDisplayName("Week")
        Preview(timeframe: .month)
            .previewDisplayName("Month")
        Preview(timeframe: .year)
            .previewDisplayName("Year")
    }
}
