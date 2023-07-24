//
//  CardNavigationHeader.swift
//  Iceme Corner
//
//  Created by Feni Brian on 24/07/2023.
//

import SwiftUI

struct CardNavigationHeader<Label: View>: View {
    var panel: Panel
    var navigation: TruckCardHeaderNavigation
    @ViewBuilder var label: Label
    
    var body: some View {
        HStack {
            switch navigation {
            case .navigationLink:
                NavigationLink(value: panel, label: { label })
            case .selection(let selection):
                Button(action: { selection.wrappedValue = panel }, label: { label })
            }
            Spacer()
        }
        .buttonStyle(.borderless)
        .labelStyle(.cardNavigationHeader)
    }
}

struct CardNavigationHeader_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CardNavigationHeader(panel: .orders, navigation: .navigationLink, label: { Label("Orders", systemImage: "shippingbox") })
        }
        .padding()
    }
}
