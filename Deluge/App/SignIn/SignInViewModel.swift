//
//  SignInViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

final class SignInViewModel: ObservableObject {
    
    @Published var isSignInErrorPresented = false
    
    let credentialsValueSubject: CurrentValueSubject<Credentials?, Never>
    var cancellable: AnyCancellable?
    
    init(credentialsValueSubject: CurrentValueSubject<Credentials?, Never>) {
        self.credentialsValueSubject = credentialsValueSubject
    }
    
    func signIn(endpoint: String, password: String) {
        
        guard let endpoint = URL(string: endpoint) else {
            isSignInErrorPresented = true
            return
        }
        
        cancellable?.cancel()
        
        let credentials = Credentials(endpoint: endpoint, password: password)
        
        cancellable = Authenticator(credentials: credentials).fetchPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { result in
                guard case .failure(let error) = result else  { return }
                print(error)
                self.isSignInErrorPresented = true

            }, receiveValue: { someValue in
                self.credentialsValueSubject.value = credentials
            })
    }
}