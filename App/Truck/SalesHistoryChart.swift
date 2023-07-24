//
//  SalesHistoryChart.swift
//  Iceme Corner
//
//  Created by Feni Brian on 24/07/2023.
//

import Charts
import SwiftUI
import FoodTruckKit

struct SalesHistoryChart: View {
    var salesByCity: [SalesByCity]
    var hideChartContent: Bool = false
    
    var body: some View {
        Chart {
            ForEach(salesByCity) { citySales in
                ForEach(citySales.entries) { entry in
                    LineMark(x: .value("Day", entry.date), y: .value("Sales", entry.sales))
                        .foregroundStyle(by: .value("Location", citySales.city.name))
                        .interpolationMethod(.cardinal)
                        .symbol(by: .value("Location", citySales.city.name))
                        .opacity(hideChartContent ? 0 : 1)
                }
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
        }
        .chartLegend(position: .top)
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXAxis {
            AxisMarks(values: .automatic(roundLowerBound: false, roundUpperBound: false)) { value in
                if value.index < value.count - 1 { AxisValueLabel() }
                AxisTick()
                AxisGridLine()
            }
        }
    }
}

struct SalesHistoryChart_Previews: PreviewProvider {
    struct Preview: View {
        private var salesByCity: [SalesByCity] = []
        var body: some View {
            SalesHistoryChart(salesByCity: salesByCity)
        }
    }
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}

struct SalesByCity: Identifiable {
    var id: String { city.id }
    var city: City
    var entries: [Entry]
    
    struct Entry: Identifiable {
        var id: Date { date }
        var date: Date
        var sales: Int
    }
}
