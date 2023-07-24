//
//  TruckSocialFeedCard.swift
//  Iceme Corner
//
//  Created by Feni Brian on 24/07/2023.
//

import SwiftUI
import FoodTruckKit

struct TruckSocialFeedCard: View {
    var navigation: TruckCardHeaderNavigation = .navigationLink
    private let tags: [SocialFeedTag] = [
        .donut(.powderedChocolate), .donut(.blueberryFrosted), .title("Warmed Up"), .title("Room Temperature"),.city(.sanFrancisco),
        .donut(.rainbow), .title("Rainbow Sprinkles"), .donut(.strawberrySprinkles),.title("Dairy Free"), .city(.cupertino),
        .city(.london), .title("Gluten Free"), .donut(.fireZest), .donut(.blackRaspberry), .title("Carrots"), .title("Donut vs Doughnut")
    ]
    
    var body: some View {
        VStack {
            CardNavigationHeader(panel: .socialFeed, navigation: navigation, label: { Label("Social Feed", systemImage: "text.bubble") })
            
            (FlowLayout(alignment: .center)) {
                ForEach(tags) { $0.label }
            }
            .labelStyle(.socialFeedTag)
            #if canImport(UIKit)
            .backgroundStyle(Color(uiColor: .quaternarySystemFill))
            #else
            .backgroundStyle(.quaternary.opacity(0.5))
            #endif
            .frame(maxWidth: .infinity, maxHeight: 180)
            .padding(.top, 15)
             
            Text("Trending Topics")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding()
            
            Spacer()
        }
        .padding(10)
        .background()
    }
}

struct TruckSocialFeedCard_Previews: PreviewProvider {
    static var previews: some View {
        TruckSocialFeedCard()
    }
}
