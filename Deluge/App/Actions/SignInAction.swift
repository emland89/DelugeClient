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
    
    var reducer: AnyReducer<AppState, AppEnvironment> {

        SyncReducer<AppState, AppEnvironment> { state, _ in
            state.session.signInState = .signingIn
        }
        
        AsyncReducer<AppState, AppEnvironment, Bool, DelugeClient.Error> { _, environment in
            environment.delugeClient.authenticatePublisher(endpoint: self.session.endpoint, password: self.session.password)
            
        } result: { state, store, isSignedIn in
            state.session.signInState = isSignedIn ? .signedIn(self.session) : .signOut
            
        } catch: { state, store, error in
            state.session.isSignInErrorShown = true
            print(error)
        }
    }
}
