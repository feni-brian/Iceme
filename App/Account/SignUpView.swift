//
//  SignUpView.swift
//  Iceme Corner
//
//  Created by Feni Brian on 30/07/2023.
//

import SwiftUI
import FoodTruckKit

struct SignUpView: View {
    @EnvironmentObject private var accountStore: AccountStore
    @FocusState private var focusedElement: FocusElement?
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var model: FoodTruckModel
    @State private var signUpType: SignUpType = .passkey
    @State private var username = ""
    @State private var password = ""
    
    
    var body: some View {
        Form {
            Section {
                TextField("User's Name", text: $username)
                    .textContentType(.username)
                #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                #endif
                    .focused($focusedElement, equals: .username)
                if case .password = signUpType {
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .focused($focusedElement, equals: .password)
                }
            } footer: {
                if case .passkey = signUpType {
                    HStack(spacing: 10) {
                        Image(systemName: "person.badge.key.fill")
                            .font(.title2)
                        Text("When you sign up with a passkey, all you need is a user name. The passkey will be available on all of your devices.")
                    }
                }
            }
            Section {
                Button("Sign Up", action: { signUp() })
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .disabled(!isFormValid)
            } footer: {
                changeSignUpTypeButton
            }
        }
        .navigationTitle("Sign Up")
        #if os(macOS)
        .defaultFocus($focusedElement, .username)
        #endif
        .toolbar {
            Button("Cancel", role: .cancel, action: { dismiss() })
        }
    }
    
    private enum FocusElement {
        case username
        case password
    }
    
    private enum SignUpType {
        case passkey
        case password
    }
    
    private var isFormValid: Bool {
        switch signUpType {
        case .passkey: return !username.isEmpty
        case .password: return !username.isEmpty && !password.isEmpty
        }
    }
    
    @ViewBuilder
    private var changeSignUpTypeButton: some View {
        Group {
            switch signUpType {
            case .passkey: Button("Sign up with password", action: { signUpType = .password })
            case .password:
                Button("Sign up with passkey") {
                    signUpType = .passkey
                    password = ""
                }
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .font(.system(.subheadline))
    }
    
    private func signUp() {
        Task { @MainActor in
            switch signUpType {
            case .passkey: try await accountStore.createPasskeyAccount(username: username)
            case .password: try await accountStore.createPasswordAccount(username: username, password: password)
            }
            dismiss()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var accountStore = AccountStore()
        @StateObject private var model = FoodTruckModel()
        var body: some View {
            SignUpView(model: model)
                .environmentObject(accountStore)
        }
    }
    
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
