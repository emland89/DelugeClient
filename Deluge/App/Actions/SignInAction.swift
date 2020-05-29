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
        
        Reducer {
            SyncReducer<AppState> { state in
                state.session.signInState = .signingIn
            }
            
            AsyncReducer<AppState, Bool, DelugeClient.Error>(publisher: { _ in
                environment.delugeClient.authenticatePublisher(endpoint: self.session.endpoint, password: self.session.password)
                
            }, result: { state, isSignedIn in
                state.session.signInState = isSignedIn ? .signedIn(self.session) : .signOut
                
            }, catch: { state, error in
                state.session.isSignInErrorShown = true
                print(error)
            })
        }
    }
}
