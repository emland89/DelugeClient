//
//  SignInAction.swift
//  Deluge
//
//  Created by Emil Landron on 5/21/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine
import SwiftyRedux

struct SignInAction: Action {
    
    let session: Session
    
    func reducer(environment: AppEnvironment) -> Reducer<AppState> {
        
        Reducer<AppState>(initial: { state in
            state.session.signInState = .signingIn
        }, value: { _ in
            self.authenticatePublisherFor(client: environment.delugeClient)
        }, final: { state, isSignedIn in
            state.session.signInState = isSignedIn ? .signedIn(self.session) : .signOut
        })
    }
    
    private func authenticatePublisherFor(client: DelugeClient) -> AnyPublisher<Bool, Never> {
        
        client.authenticatePublisher(endpoint: session.endpoint, password: session.password)
        .map { $0 }
        .catch { error -> Just<Bool> in
            print(error)
            return Just(false)
        }
        .eraseToAnyPublisher()
    }
}
