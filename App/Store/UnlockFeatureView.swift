//
//  UnlockFeatureView.swift
//  Iceme Corner
//
//  Created by Feni Brian on 26/07/2023.
//

import SwiftUI
import StoreKit
import FoodTruckKit

struct UnlockFeatureView: View {
    @ObservedObject var controller: StoreProductController
    @State private var isExpanded: Bool = true
    @Environment(\.colorScheme) private var colourScheme
    
    private static var backgroundShape: some InsettableShape {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
    }
    private static var backgroundColour: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .windowBackgroundColor)
        #endif
    }
    
    var body: some View {
        if let product = controller.product, !controller.isEntitled {
            Group {
                if isExpanded {
                    UnlockFeatureExpandedView(product: product) {
                        Task (priority: .userInitiated, operation: { await controller.purchase() })
                    } onDismiss: {
                        isExpanded = false
                    }
                } else {
                    UnlockFeatureSimpleView(product: product) {
                        isExpanded = true
                        Task(priority: .userInitiated, operation: { await controller.purchase() })
                    }
                    .onTapGesture { isExpanded = true }
                }
            }
            .frame(maxWidth: 400)
            .background(UnlockFeatureView.backgroundColour, in: UnlockFeatureView.backgroundShape)
            .background(.shadow(.drop(color: .black.opacity(colourScheme == .dark ?  0.5 : 0.2), radius: 10)), in: UnlockFeatureView.backgroundShape.scale(0.99))
            .padding()
        }
    }
}

struct UnlockFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            UnlockFeatureView(controller: StoreActor.shared.productController)
        }
    }
}

struct UnlockFeatureExpandedView: View {
    let product: Product
    let onPurchase: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Unlock a \(product.displayName.localizedLowercase) for only \(product.displayPrice)")
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)
            Text("Get the full picture with data and insights that cover an entire year.")
                .font(.subheadline)
            Button(action: onPurchase) {
                Text("Unlock")
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
            }
            .buttonStyle(.borderedProminent)
            #if os(iOS)
            .buttonBorderShape(.capsule)
            #endif
        }
        .multilineTextAlignment(.center)
        .padding()
        .padding(.top, 30)
        .padding(.bottom)
        .overlay(alignment: .topTrailing) {
            Button(action: onDismiss) {
                Label("Dismiss", systemImage: "xmark")
                    .labelStyle(.iconOnly)
            }
            .controlSize(.mini)
            .foregroundColor(.secondary)
            .padding(.top)
            .padding(.trailing, 10)
        }
    }
}

struct UnlockFeatureSimpleView: View {
    let product: Product
    let onPurchase: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Unlock a \(product.displayName.localizedLowercase)")
                    .font(.subheadline.weight(.semibold))
                Text("for only \(product.displayPrice)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: onPurchase) {
                Text("Unlock")
                    .font(.subheadline)
                    .padding(2)
            }
            .buttonStyle(.borderedProminent)
            #if os(iOS)
            .buttonBorderShape(.capsule)
            #endif
        }
        .padding()
    }
}
