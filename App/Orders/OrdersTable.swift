//
//  OrdersTable.swift
//  Iceme Corner
//
//  Created by Feni Brian on 22/07/2023.
//

import SwiftUI
import FoodTruckKit

struct OrdersTable: View {
    @ObservedObject var model: FoodTruckModel
    @State private var sortOrder = [KeyPathComparator(\Order.status, order: .reverse)]
    @Binding var selection: Set<Order.ID>
    @Binding var completedOrder: Order?
    @Binding var searchText: String
    
    var orders: [Order] {
        model.orders.filter { order in
            order.matches(searchText: searchText) || order.donuts.contains(where: { $0.matches(searchText: searchText) })
        }
        .sorted(using: sortOrder)
    }
    
    var body: some View {
        Table(selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Order", value: \.id) { order in
                OrderRow(order: order)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
            }
            TableColumn("Donuts", value: \.totalSales) { order in
                Text(order.totalSales.formatted())
                    .monospacedDigit()
                    #if os(macOS)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.secondary)
                    #endif
            }
            TableColumn("Status", value: \.status) { order in
                order.status.label
                    #if os(macOS)
                    .foregroundStyle(.secondary)
                    #endif
            }
            TableColumn("Date", value: \.creationDate) { order in
                Text(order.formattedDate)
                    #if os(macOS)
                    .foregroundStyle(.secondary)
                    #endif
            }
            TableColumn("Details") { order in
                Menu {
                    NavigationLink(value: order.id) { Label("View Details", systemImage: "list.bullet.below.rectangle") }
                    
                    if !order.isComplete {
                        Section {
                            Button {
                                model.markOrderAsCompleted(id: order.id)
                                completedOrder = order
                            } label: { Label("Complete Order", systemImage: "checkmark") }
                        }
                    }
                } label: {
                    Label("Details", systemImage: "ellipsis.circle")
                        .labelStyle(.iconOnly)
                        .contentShape(Rectangle())
                }
                .menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
                .fixedSize()
                .foregroundStyle(.secondary)
            }
            .width(60)
        } rows: {
            Section {
                ForEach(orders) { order in
                    TableRow(order)
                }
            }
        }
    }
}

struct OrdersTable_Previews: PreviewProvider {
    @State private var sortOrder = [KeyPathComparator(\Order.status, order: .reverse)]
    
    struct Preview: View {
        @StateObject private var model = FoodTruckModel.preview
        var body: some View {
            OrdersTable(model: model, selection: .constant([]), completedOrder: .constant(nil), searchText: .constant(""))
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
