//
//  SessionState.swift
//  Deluge
//
//  Created by Emil Landron on 5/23/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import KeychainStored

struct SessionState {
    
    // MARK: - Types

    enum SignInState {
        case signOut, signingIn, signedIn(Session)
        
        var session: Session? {
            guard case .signedIn(let session) = self else { return nil }
            return session
        }
    }
    
    // MARK: - Static Properties
    
    @KeychainStored(service: "com.deluge.session", encoder: JSONEncoder(), decoder: JSONDecoder()) private static var savedSession: Session?

    // MARK: - Properties
    
    var signInState: SignInState {
        didSet {
            if case .signedIn(let session) = signInState  {
                Self.savedSession = session
            }
            else {
                Self.savedSession = nil
            }
        }
    }
    
    // MARK: - Life Cycle

    init() {
        if let session = Self.savedSession {
            signInState = .signedIn(session)
        }
        else {
            signInState = .signOut
        }
    }
}
