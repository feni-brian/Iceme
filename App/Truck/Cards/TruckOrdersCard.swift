//
//  TruckOrdersCard.swift
//  Iceme Corner
//
//  Created by Feni Brian on 24/07/2023.
//

import SwiftUI
import FoodTruckKit

struct TruckOrdersCard: View {
    @ObservedObject var model: FoodTruckModel
    @State private var pulseOrderText: Bool = false
    var orders: [Order] { model.orders }
    var navigation: TruckCardHeaderNavigation = .navigationLink
    
    var body: some View {
        VStack(alignment: .leading) {
            CardNavigationHeader(panel: .orders, navigation: navigation, label: { Label("New Orders", systemImage: "shippingbox") })
            
            HeroSquareTilingLayout() {
                ForEach(orders.reversed().prefix(5)) { order in
                    let iconShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
                    DonutStackView(donuts: order.donuts)
                        .padding(6)
                        #if canImport(UIKit)
                        .background(Color(uiColor: .tertiarySystemFill), in: iconShape)
                        #else
                        .background(.quaternary.opacity(0.5), in: iconShape)
                        #endif
                        .overlay(content: { iconShape.strokeBorder(.quaternary, lineWidth: 0.5) })
                        .transition(.asymmetric(insertion: .offset(x: -100).combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                }
                .aspectRatio(1, contentMode: .fit)
            }
            .aspectRatio(2, contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: 250)
            
            if let order = orders.last {
                HStack {
                    Text(order.id)
                    Image.donutSymbol
                    Text(order.totalSales.formatted())
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(pulseOrderText ? .primary : .secondary)
                .fontWeight(pulseOrderText ? .bold : .regular)
                .contentTransition(.interpolate)
            }
        }
        .padding(10)
        .clipShape(ContainerRelativeShape())
        .background()
        .onChange(of: orders.last) { newValue in
            Task(priority: .background) {
                try await Task.sleep(nanoseconds: .secondsToNanoseconds(0.1))
                Task { @MainActor in
                    withAnimation(.spring(response: 0.25, dampingFraction: 1)) {
                        pulseOrderText = true
                    }
                }
                try await Task.sleep(nanoseconds: .secondsToNanoseconds(1))
                Task { @MainActor in
                    withAnimation(.spring(response: 0.25, dampingFraction: 1)) {
                        pulseOrderText = false
                    }
                }
            }
        }
    }
}

struct TruckOrdersCard_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        var body: some View {
            TruckOrdersCard(model: model)
        }
    }
    
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}

struct HeroSquareTilingLayout: Layout {
    var spacing: Double
    
    init(spacing: Double) {
        self.spacing = spacing
    }
    
    init() {
        self.spacing = 10
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = proposal.replacingUnspecifiedDimensions(by: CGSize(width: 100, height: 100))
        let heroLength = min((size.width - spacing) * 0.5, size.height)
        let boundsWidth = heroLength * 2 + spacing
        return CGSize(width: boundsWidth, height: heroLength)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let heroLength = min((bounds.width - spacing) * 0.5, bounds.height)
        let boundsWidth = heroLength * 2 + spacing
        let halfRectSize = CGSize(width: boundsWidth, height: heroLength)
        let titleLength = (heroLength - 10) * 0.5
        let heroOrigin = CGPoint(
            x: bounds.origin.x + ((bounds.width - boundsWidth) * 0.5),
            y: bounds.origin.y + ((bounds.height - heroLength) * 0.5)
        )
        let titlesOrigin = CGPoint(x: heroOrigin.x + heroLength + spacing, y: heroOrigin.y)
        let titlesRect = CGRect(origin: titlesOrigin, size: halfRectSize)
        
        for index in subviews.indices {
            if index == 0 {
                // Hero cell.
                subviews[index].place(at: heroOrigin, anchor: .topLeading, proposal: ProposedViewSize(halfRectSize))
            } else {
                // Smaller tile.
                let titleIndex = index + 1
                let xPos: Double = titleIndex % 2 == 0 ? 0 : 1
                let yPos: Double = titleIndex < 2 ? 0 : 1
                let point = CGPoint(x: titlesRect.minX + (xPos * titlesRect.width), y: titlesRect.minY + (yPos * titlesRect.height))
                subviews[index].place(at: point, anchor: UnitPoint(x: xPos, y: yPos), proposal: ProposedViewSize(width: titleLength, height: titleLength))
            }
        }
    }
}
