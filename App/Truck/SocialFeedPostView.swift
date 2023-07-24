//
//  SocialFeedPostView.swift
//  Iceme Corner
//
//  Created by Feni Brian on 24/07/2023.
//

import SwiftUI
import FoodTruckKit

struct SocialFeedPostView: View {
    var post: SocialFeedPost
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                DonutView(donut: post.favoriteDonut)
                    .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                    .padding(.top, 5)
                    .padding([.horizontal, .bottom], 6)
                    .background(post.favoriteDonut.dough.backgroundColor.gradient, in: Circle())
                    .overlay {
                        Circle()
                            .strokeBorder(lineWidth: 0.5)
                            .foregroundStyle(.tertiary)
                            .blendMode(colorScheme == .light ? .plusDarker : .plusLighter)
                    }
                    .frame(width: 35, height: 35)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(post.message)
                        .font(.title3)
                    FlowLayout(alignment: .topLeading) {
                        ForEach(post.tags) { tag in
                            tag.label
                                .labelStyle(.socialFeedTag)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .backgroundStyle(tagBackgroundStyle)
                    
                    Text(dateString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8))
    }
    
    var dateString: String {
        let day: String = {
            if Calendar.current.isDateInToday(post.date) {
                return String(localized: "Today")
            } else if Calendar.current.isDateInYesterday(post.date) {
                return String(localized: "Yesterday")
            } else {
                return post.date.formatted(date: .abbreviated, time: .omitted)
            }
        }()
        return String(localized: "\(day), \(post.date.formatted(date: .omitted, time: .shortened))")
    }
    
    var tagBackgroundStyle: AnyShapeStyle {
        #if canImport(UIKit)
        return AnyShapeStyle(Color(uiColor: .quaternarySystemFill))
        #else
        return AnyShapeStyle(.quaternary.opacity(0.5))
        #endif
    }
}
/*
 WARNING : 
 !!!This view provider may crash at times!!!!
 */
struct SocialFeedPostView_Previews: PreviewProvider {
    static var previews: some View {
        let post = SocialFeedPost(
            favoriteDonut: .lemonChocolate,
            message: "My favourite!!!",
            date: .now,
            tags: [.title("A cool tag"), .donut(.lemonChocolate), .city(.london)]
        )
        SocialFeedPostView(post: post)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
