//
//  SocialFeedView.swift
//  Iceme Corner
//
//  Created by Feni Brian on 24/07/2023.
//

import SwiftUI
import FoodTruckKit

struct SocialFeedView: View {
    @ObservedObject var subscriptionController = StoreActor.shared.subscriptionController
    @State private var manageSocialFeedPlusIsPresented = false
    @State private var storeIsPresented = false
    var hasPlus: Bool {
        subscriptionController.entitledSubscriptionID != nil
    }
    var navigationTitle: LocalizedStringKey {
        if hasPlus {
            return "Social Feed+"
        }
        return "Social Feed"
    }
    
    var body: some View {
        WidthThresholdReader { proxy in
            List {
                if !hasPlus {
                    SocialFeedPlusMarketingView(storeIsPresented: $storeIsPresented)
                } else {
                    Section("Highlighted Post") {
                        ForEach(SocialFeedPost.additionalContent) { post in
                            SocialFeedPostView(post: post)
                        }
                    }
                }
                Section("Post") {
                    ForEach(SocialFeedPost.standardContent) { post in
                        SocialFeedPostView(post: post)
                    }
                }
            }
            .toolbar {
                if subscriptionController.entitledSubscriptionID != nil {
                    Button {
                        manageSocialFeedPlusIsPresented = true
                    } label: {
                        Label("Subscription Options", systemImage: "plus.bubble")
                    }
                }
            }
        }
        .navigationTitle(navigationTitle)
        .sheet(isPresented: $storeIsPresented) {
            SubscriptionStoreView(controller: subscriptionController)
                #if os(macOS)
                .frame(minWidth: 400, minHeight: 400)
                #endif
        }
        .sheet(isPresented: $manageSocialFeedPlusIsPresented) {
            NavigationStack {
                SocialFeedPlusSettings(controller: subscriptionController)
                    #if os(macOS)
                    .frame(minWidth: 300, minHeight: 300)
                    #endif
            }
        }
    }
}
/*
 WARNING :
 !!!This view provider is may crash at times.!!!!
 */
struct SocialFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SocialFeedView()
        }
    }
}

struct SocialFeedPlusMarketingView: View {
    @Binding var storeIsPresented: Bool
    #if os(macOS)
    @Environment(\.colorScheme) private var colorScheme
    #endif
    
    var body: some View {
        Section {
            VStack(alignment: .center, spacing: 5) {
                Text("Get Social Feed+")
                    .font(.title2)
                    .bold()
                Text("The definitive social-feed experience")
                    .font(.subheadline)
                Button {
                    storeIsPresented = true
                } label: {
                    Text("Get Started")
                        .bold()
                        .padding(.vertical, 2)
                        #if os(macOS)
                        .foregroundColor(colorScheme == .light ? .accentColor : .white)
                        #endif
                }
                #if os(iOS)
                .buttonStyle(.borderedProminent)
                .foregroundColor(.accentColor)
                #elseif os(macOS)
                .buttonStyle(.bordered)
                #endif
                .tint(.white)
                .padding(.top)
            }
            .foregroundColor(.white)
            .padding(10)
            .frame(maxWidth: .infinity)
        }
        #if os(iOS)
        .listRowBackground(Rectangle().fill(.indigo.gradient))
        #elseif os(macOS)
        .background(.indigo.gradient)
        .cornerRadius(10)
        #endif
    }
}
