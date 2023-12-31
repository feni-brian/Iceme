//
//  OrderRow.swift
//  Iceme Corner
//
//  Created by Feni Brian on 22/07/2023.
//

import SwiftUI
import FoodTruckKit

struct OrderRow: View {
    var order: Order
    
    var body: some View {
        HStack {
            let iconShape = RoundedRectangle(cornerRadius: 4, style: .continuous)
            DonutStackView(donuts: order.donuts)
                .padding(2)
            #if os(iOS)
                .frame(width: 40, height: 40)
            #else
                .frame(width: 20, height: 20)
            #endif
                .background(in: iconShape)
                .overlay(content: { iconShape.strokeBorder(.quaternary, lineWidth: 0.5) })
            
            Text(order.id)
        }
    }
}

struct OrderRow_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        var body: some View {
            OrderRow(order: .preview)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
