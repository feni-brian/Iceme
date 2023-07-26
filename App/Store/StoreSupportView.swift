//
//  StoreSupportView.swift
//  Iceme Corner
//
//  Created by Feni Brian on 26/07/2023.
//

import SwiftUI
import StoreKit
import FoodTruckKit

struct StoreSupportView: View {
    @Environment(\.dismiss) private var dismiss
    #if os(iOS)
    @State private var manageSubscriptionSheetIsPresented: Bool = false
    #endif
    
    var body: some View {
        List {
            #if os(iOS)
            Button("Manage subscription", action: { manageSubscriptionSheetIsPresented = true })
                .manageSubscriptionsSheet(isPresented: $manageSubscriptionSheetIsPresented)
            NavigationLink("Refund purchases", destination: { RefundView() })
                .foregroundColor(.accentColor)
            #endif
            Button("Restore missing purchases") {
                Task(priority: .userInitiated) {
                    try await AppStore.sync()
                }
            }
        }
        .navigationTitle("Help with purchases")
    }
}

struct StoreSupportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StoreSupportView()
        }
    }
}
