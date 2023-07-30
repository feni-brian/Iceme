//
//  AccountView.swift
//  Iceme Corner
//
//  Created by Feni Brian on 30/07/2023.
//

import SwiftUI
import StoreKit
import FoodTruckKit

struct AccountView: View {
    @EnvironmentObject private var accountStore: AccountStore
    @ObservedObject var model: FoodTruckModel
    @State private var isSignUpSheetPresented: Bool = false
    @State private var isSignOutAlertPresented: Bool = false
    
    var body: some View {
        List {
            if case let .authenticated(username) = accountStore.currentUser {
                Section {
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.accentColor.gradient, in: Circle())
                        Text(username)
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.medium)
                    }
                }
            }
            #if os(iOS)
            NavigationLink(value: "In-app purhcase support") {
                Label("In-app purchase support", systemImage: "questionmark.circle")
            }
            #else
            Section {
                Button("Restore missing purchase") {
                    Task(priority: .userInitiated, operation: { try await AppStore.sync() })
                }
                .frame(maxWidth: .infinity)
            }
            #endif
            
            Section {
                if accountStore.isSignedIn {
                    Button("Sign Out", role: .destructive, action: { isSignOutAlertPresented = true })
                        .frame(maxWidth: .infinity)
                } else {
                    Button("Sign In", action: { signIn() })
                    Button("Sign Up", action: { isSignUpSheetPresented = true })
                }
            }
        }
        .navigationTitle("Account")
        #if os(iOS)
        .navigationDestination(for: String.self) { _ in
            StoreSupportView()
        }
        #endif
        .sheet(isPresented: $isSignUpSheetPresented) {
            NavigationStack {
                SignUpView(model: model)
            }
        }
        .alert(isPresented: $isSignOutAlertPresented, content: { signOutAlert })
    }
    
    private var signOutAlert: Alert {
        Alert(
            title: Text("Are you sure you want to sign out?"),
            primaryButton: .destructive(Text("Sign Out")) { accountStore.signOut() },
            secondaryButton: .cancel()
        )
    }
    
    private func signIn() {
        Task { @MainActor in
            try await accountStore.signIn()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        @StateObject private var accountStore = AccountStore()
        var body: some View {
            AccountView(model: model)
                .environmentObject(accountStore)
        }
    }
    
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
