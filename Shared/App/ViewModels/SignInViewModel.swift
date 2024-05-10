//
//  SignInViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 11/10/21.
//  Copyright © 2021 Emil Landron. All rights reserved.
//

import Foundation

@Observable
final class SignInViewModel {
    
    var endpoint = "https://deluge.orembo.com"
    var password = "@Mira0329"
    var isSignInErrorAlertPresented = false
    private(set) var isSigningIn = false

    var isSignInActionEnabled: Bool {
        !endpoint.isEmpty && !password.isEmpty && !isSigningIn
    }
    
    private let onSignedIn: (DelugeClient) -> Void


    init(onSignedIn: @escaping (DelugeClient) -> Void) {
        self.onSignedIn = onSignedIn
    }

    func signIn() {
        // TODO: Show error if bad URL
        guard !isSigningIn, let endpoint = URL(string: endpoint) else { return }

        Task {
            isSigningIn = true
            
            let client = DelugeClient(endpoint: endpoint, password: password)
            
            do {
                try await client.login()
                onSignedIn(client)
            }
            catch {
                isSignInErrorAlertPresented = true
            }
            
            isSigningIn = false
        }
    }
}
