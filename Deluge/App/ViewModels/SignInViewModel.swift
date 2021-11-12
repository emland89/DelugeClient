//
//  SignInViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 11/10/21.
//  Copyright © 2021 Emil Landron. All rights reserved.
//

import Foundation

@MainActor
final class SignInViewModel: ObservableObject {
    
    @Published var endpoint = "https://deluge.orembo.com"
    @Published var password = "@Mira0329"
    @Published var isSignInErrorAlertPresented = false
    @Published private(set) var isSigningIn = false

    private var clientContinuation: CheckedContinuation<DelugeClient, Never>?
    
    var isSignInEnabled: Bool {
        !endpoint.isEmpty && !password.isEmpty
    }
    
    func signIn() {
        guard let endpoint = URL(string: endpoint) else { return }
        
        Task {
            isSigningIn = true
            
            let client = DelugeClient(endpoint: endpoint, password: password)
            
            do {
                try await client.login()
                clientContinuation?.resume(returning: client)
            }
            catch {
                isSignInErrorAlertPresented = true
            }
            
            isSigningIn = false
        }
    }
    
    func client() async -> DelugeClient {
        await withCheckedContinuation { (continuation: CheckedContinuation<DelugeClient, Never>) in
            clientContinuation = continuation
        }
    }
}
