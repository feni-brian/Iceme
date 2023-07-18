//
//  CityWeatherCard.swift
//  Iceme Corner
//
//  Created by Feni Brian on 18/07/2023.
//

import SwiftUI
import WeatherKit

struct CityWeatherCard: View {
    var condition: WeatherCondition
    var willRainSoon: Bool
    var symbolName: String
    
    var body: some View {
        HStack {
            Image(systemName: symbolName)
                .foregroundColor(.secondary)
                .imageScale(.large)
            
            VStack {
                Text(condition.description)
                    .font(.headline)
                Text(willRainSoon ? "Will rain soon..." : "No chance of rain today!")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .frame(maxWidth: 400, alignment: .trailing)
        .padding()
    }
}

struct CityWeatherCard_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherCard(condition: .partlyCloudy, willRainSoon: true, symbolName: "sun.max")
    }
}
