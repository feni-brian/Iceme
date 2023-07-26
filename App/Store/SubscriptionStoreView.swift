//
//  SubscriptionStoreView.swift
//  Iceme Corner
//
//  Created by Feni Brian on 26/07/2023.
//

import SwiftUI
import StoreKit
import FoodTruckKit

struct SubscriptionStoreView: View {
    @ObservedObject var controller: StoreSubscriptionController
    @State private var selectedSubscription: Subscription?
    @State private var errorAlertIsPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            #if os(macOS)
            VStack(spacing: 0) {
                SubscriptionStoreHeaderView()
                    .frame(maxWidth: .infinity)
                    .background(.indigo.gradient)
                subscriptionCellsView
            }
            .safeAreaInset(edge: .bottom, content: { subscriptionPurchaseView })
            .overlay(alignment: .topTrailing) {
                dismissButton
                    .padding()
            }
            #else
            GeometryReader { proxy in
                if proxy.size.height > proxy.size.width {
                    VStack(spacing: 0) {
                        SubscriptionStoreHeaderView()
                            .frame(maxWidth: .infinity)
                            .background(.indigo.gradient)
                        subscriptionCellsView
                    }
                    .safeAreaInset(edge: .bottom, content: { subscriptionPurchaseView })
                    .overlay(alignment: .topTrailing) {
                        dismissButton
                            .padding()
                    }
                } else {
                    HStack(spacing: 0) {
                        SubscriptionStoreHeaderView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.indigo.gradient)
                        Divider()
                            .ignoresSafeArea()
                        VStack {
                            subscriptionCellsView
                                .padding(.top ,30)
                                .frame(width: 400)
                                .ignoresSafeArea()
                            subscriptionPurchaseView
                                .padding(.horizontal, 30)
                        }
                    }
                }
            }
            #endif
        }
        #if os(iOS)
        .background(Color(uiColor: .systemGray6))
        #endif
        .onAppear { selectedSubscription = controller.subscriptions.first }
        .alert(controller.purchaseError?.errorDescription ?? "", isPresented: $errorAlertIsPresented, actions: {})
    }
    
    var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circe.fill")
                .symbolRenderingMode(.palette)
                #if os(iOS)
                .foregroundStyle(.secondary, .clear, Color(uiColor: .systemGray))
                #elseif os(macOS)
                .foregroundStyle(.secondary, .clear, Color(nsColor: .lightGray))
                #endif
        }
        .buttonStyle(.borderless)
        .opacity(0.8)
        .font(.title)
    }
    
    var subscriptionPurchaseView: some View {
        SubscriptionPurchaseView(selectedSubscription: selectedSubscription) {
            if let subscription = selectedSubscription {
                Task(priority: .userInitiated) { @MainActor in
                    let action = await controller.purchase(option: subscription)
                    switch action {
                    case .dismissStore: dismiss()
                    case .displayError: errorAlertIsPresented = true
                    case .noAction: break
                    }
                }
            }
        }
        .backgroundStyle(.ultraThinMaterial)
    }
    
    var subscriptionCellsView: some View {
        ScrollView(.vertical) {
            if let subscriptions = controller.subscriptions.isEmpty ? nil : controller.subscriptions {
                SubscriptionStoreOptionsView(subscriptions: subscriptions, selectedOption: $selectedSubscription)
                    .padding(.top)
            }
        }
    }
}

struct SubscriptionStoreView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionStoreView(controller: StoreActor.shared.subscriptionController)
    }
}

struct SubscriptionStoreHeaderView: View {
    var body: some View {
        VStack {
            Text("Social Feed+")
                .font(.largeTitle)
                .bold()
                .padding()
            Group {
                Text("Top social-media providers.")
                Text("Advanced engagement tools.")
                Text("All in one place.")
            }
            .font(.headline)
        }
        .padding(.top, 5)
        .padding(.bottom, 30)
        .foregroundColor(.white)
    }
}

struct SubscriptionStoreOptionsView: View {
    let subscriptions: [Subscription]
    @Binding var selectedOption: Subscription?
    
    var body: some View {
        VStack {
            ForEach(subscriptions) { subscription in
                subscriptionOptionCell(for: subscription)
            }
        }
    }
    
    func binding(for subscription: Subscription) -> Binding<Bool> {
        Binding(get: { selectedOption?.id == subscription.id }, set: { selectedOption = $0 ? subscription : nil })
    }
    
    func subscriptionOptionCell(for subscription: Subscription) -> some View {
        var savingsInfo: SubscriptionSavings?
        if subscription.id == StoreActor.socialFeedYearlyID { savingsInfo = self.savings() }
        return SubscriptionOptionView(subscription: subscription, savings: savingsInfo, isOn: binding(for: subscription))
    }
    
    func savings() -> SubscriptionSavings? {
        guard let monthlySubscription = subscriptions.first(where: { $0.id == StoreActor.socialFeedMonthlyID }) else { return nil }
        guard let yearlySubscription = subscriptions.first(where: { $0.id == StoreActor.socialFeedYearlyID }) else { return nil }
        let yearlyPriceForMonthlySubscription = 12 * monthlySubscription.price
        let amountSaved = yearlyPriceForMonthlySubscription - yearlySubscription.price
        guard amountSaved > 0 else { return nil }
        let percentSaved = amountSaved / yearlyPriceForMonthlySubscription
        let monthlyPrice = yearlySubscription.price / 12
        
        return SubscriptionSavings(percentSavings: percentSaved, granularPrice: monthlyPrice, granularPricePeriod: .month)
    }
}

struct SubscriptionOptionView: View {
    let subscription: Subscription
    let savings: SubscriptionSavings?
    @Binding var isOn: Bool
    @Environment(\.colorScheme) private var colourScheme
    private static var backgroundShape: some InsettableShape { RoundedRectangle(cornerRadius: 16, style: .continuous) }
    private var savingsText: String? { savings.map({ "\($0.formattedPrice(for: subscription)) (Save \($0.formattedPercent)" }) }
    
    private static var backgroundColour: Color {
        #if canImport(UIKit)
        Color(uiColor: .tertiarySystemBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .windowBackgroundColor)
        #endif
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading) {
                Text(subscription.displayName)
                    .font(.headline)
                Text(subscription.description)
                    .padding(.bottom, 2)
                Text(applyKerning(to: "/", in: subscription.priceText))
                if let savingsText = savingsText {
                    Text(applyKerning(to: "/()", in: savingsText))
                        .foregroundColor(.accentColor)
                }
            }
            Spacer()
            checkmarkImage
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Self.backgroundColour, in: Self.backgroundShape)
        .overlay {
            Self.backgroundShape
            #if os(iOS)
                .strokeBorder(Color.accentColor, lineWidth: isOn ? 1 : 0)
            #elseif os(macOS)
                .strokeBorder(isOn ? Color.accentColor : gray.opacity(0.1), lineWidth: 1)
            #endif
        }
        .onTapGesture { isOn.toggle() }
        .background(.shadow(.drop(color: .black.opacity(colourScheme == .dark ? 0.5 : 0.2), radius: 10)), in: Self.backgroundShape.scale(0.99))
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    private var checkmarkImage: some View {
        Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
            .symbolRenderingMode(.palette)
            .foregroundStyle(isOn ? Color.white : Color.secondary, Color.clear, Color.accentColor)
            .font(.title2)
    }
    
    private func applyKerning(to symbols: String, in text: String, kerningValue: CGFloat = 1.0) -> AttributedString {
        var attributedString = AttributedString(text)
        let characters = symbols.map(String.init)
        
        for character in characters {
            if let range = attributedString.range(of: character) {
                attributedString[range].kern = kerningValue
            }
        }
        
        return attributedString
    }
}

struct SubscriptionPurchaseView: View {
    @State private var canRedeemFirstOffer: Bool = false
    #if os(iOS)
    @State private var redeemSheetIsPresented: Bool = false
    #endif
    @Environment(\.dismiss) private var dismiss
    let selectedSubscription: Subscription?
    let onPurchase: () -> Void
    
    var body: some View {
        VStack {
            Button {
                onPurchase()
            } label: {
                Group {
                    if canRedeemFirstOffer {
                        Text("Start trial offer")
                    } else {
                        Text("Subscribe")
                    }
                }
                .bold()
                .padding(5)
                #if os(iOS)
                .frame(maxWidth: .infinity)
                #endif
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedSubscription == nil)
            .padding(.horizontal)
            #if os(macOS)
            .tint(.accentColor)
            .controlSize(.large)
            #endif
            
            #if os(iOS)
            Button("Redeem an offer") { redeemSheetIsPresented = true }
                .buttonStyle(.borderless)
                .padding(.top)
            #endif
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        #if os(iOS)
        .offerCodeRedemption(isPresented: $redeemSheetIsPresented) { _ in
            dismiss()
        }
        #endif
        .onChange(of: selectedSubscription) { newValue in
            guard let selectedSubscription = newValue?.subscriptionInfo else { return }
            Task(priority: .utility) { @MainActor in
                canRedeemFirstOffer = await selectedSubscription.isEligibleForIntroOffer
            }
        }
    }
}
