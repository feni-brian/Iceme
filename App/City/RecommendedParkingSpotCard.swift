//
//  RecommendedParkingSpotCard.swift
//  Iceme Corner
//
//  Created by Feni Brian on 18/07/2023.
//

import SwiftUI
import WeatherKit
import FoodTruckKit

struct RecommendedParkingSpotCard: View {
    var parkingSpot: ParkingSpot
    var condition: WeatherCondition
    var temperature: Measurement<UnitTemperature>
    var symbolName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Recommended")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.tertiary)
                Text(parkingSpot.name)
                Text("Parking Spot")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .layoutPriority(1)
            
            Spacer()
            
            ViewThatFits {
                HStack {
                    Label(temperature.formatted(), systemImage: symbolName)
                    Label("Popular", systemImage: "person.3")
                    Label("Trending", systemImage: "chart.line.uptrend.xyaxis")
                }
                HStack {
                    Label(temperature.formatted(), systemImage: symbolName)
                    Label("Popular", systemImage: "person.3")
                }
                Label(temperature.formatted(), systemImage: symbolName)
            }
            .labelStyle(RecommendedSpotSummaryLabelStyle())
        }
        .padding()
        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct RecommendedParkingSpotCard_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedParkingSpotCard(
            parkingSpot: City.cupertino.parkingSpots[0],
            condition: .clear,
            temperature: Measurement(value: 30, unit: .celsius),
            symbolName: "sun.max"
        )
    }
}

struct RecommendedSpotSummaryLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
        }
    }
}
