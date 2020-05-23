//
//  StartupAction.swift
//  Deluge
//
//  Created by Emil Landron on 5/22/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import SwiftyRedux
import KeychainStored

struct StartupAction: Action {

    @KeychainStored(service: "com.deluge.session", encoder: JSONEncoder(), decoder: JSONDecoder()) private static var session: Session?


    func reducer(environment: AppEnvironment) -> Reducer<AppState> {
        
        Reducer<AppState> { state in
            
            if let session = Self.session {
                state.signInState = .signedIn(session)
            }
            else {
                state.signInState = .signout
            }
        }
    }
}
