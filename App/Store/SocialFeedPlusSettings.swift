//
//  SocialFeedPlusSettings.swift
//  Iceme Corner
//
//  Created by Feni Brian on 26/07/2023.
//

import SwiftUI
import StoreKit
import FoodTruckKit

struct SocialFeedPlusSettings: View {
    @AppStorage("showPlusPosts") private var showPlusPosts: Bool = false
    @AppStorage("advancedTools") private var advancedTools: Bool = true
    @ObservedObject var controller: StoreSubscriptionController
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            SubscriptonStatusView(controller: controller)
            Section("Settings") {
                Toggle("Highlight Social Feed+ posts", isOn: $showPlusPosts)
                Toggle("Advanced engagement tools", isOn: $advancedTools)
                NavigationLink("Social-media providers", destination: EmptyView())
            }
            #if os(iOS)
            Section {
                NavigationLink {
                    StoreSupportView()
                } label: {
                    Label("Subscripton support", systemImage: "questionmark.circle")
                }
            }
            #else
            Section("Subscription support") {
                Button("Restore missing purchases") {
                    Task(priority: .userInitiated) {
                        try await AppStore.sync()
                    }
                }
            }
            #endif
        }
        .navigationTitle("Manage Social Feed+")
        .toolbar {
            #if os(iOS)
            let placement = ToolbarItemPlacement.navigationBarTrailing
            #else
            let placement = ToolbarItemPlacement.cancellationAction
            #endif
            ToolbarItemGroup(placement: placement) {
                Button {
                    dismiss()
                } label: {
                    Label("Dismiss", systemImage: "xmark")
                    #if os(macOS)
                        .labelStyle(.titleOnly)
                    #endif
                }
            }
        }
        .onAppear {
            // The user might lose their entitlement while this view is in the navigation stack.
            // In this case you need to dismiss the view.
            if controller.entitledSubscription == nil { dismiss() }
        }
    }
}

struct SocialFeedPlusSettings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SocialFeedPlusSettings(controller: StoreActor.shared.subscriptionController)
        }
    }
}

struct SubscriptonStatusView: View {
    @ObservedObject var controller: StoreSubscriptionController
    #if os(iOS)
    @State private var manageSubscriptionIsPresented: Bool = false
    #else
    @Environment(\.openURL) private var openURL
    #endif
    var currentSubscriptionName: String { controller.entitledSubscription?.displayName ?? String(localized: "No current subscription.") }
    
    var newNextSubscriptionName: String? {
        if controller.entitledSubscriptionID != controller.autoRenewPreference { return controller.nextSubscription?.displayName }
        return nil
    }
    
    var renewalText: String {
        let expiration = controller.expirationDate?.formatted(date: .abbreviated, time: .omitted) ?? String(localized: "N/A")
        guard let nextSubscription = controller.nextSubscription else { return String(localized: "Expires on \(expiration)") }
        let prefix: String
        if let newNextSubscriptionName = newNextSubscriptionName {
            prefix = String(localized: "Renews to \(newNextSubscriptionName)")
        } else {
            prefix = String(localized: "Renews")
        }
        let price = nextSubscription.displayPrice
        return String(localized: "\(prefix) for \(price) on \(expiration)")
    }
    
    var body: some View {
        Section("Your subscription") {
            VStack(alignment: .leading) {
                Text(currentSubscriptionName)
                    .font(.subheadline)
                    .bold()
                Text(renewalText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Button("Manage subscription") {
                #if os(iOS)
                manageSubscriptionIsPresented = true
                #else
                if let url = URL(string: "") { openURL(url) }
                #endif
            }
            #if os(iOS)
            .manageSubscriptionsSheet(isPresented: $manageSubscriptionIsPresented)
            #endif
        }
    }
}
