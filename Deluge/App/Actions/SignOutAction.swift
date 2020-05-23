//
//  SignOutAction.swift
//  Deluge
//
//  Created by Emil Landron on 5/22/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import SwiftyRedux

struct SignOutAction: Action {
        
    func reducer(environment: AppEnvironment) -> Reducer<AppState> {
        
        Reducer<AppState> { state in
            state.selectedTab = 0
            state.signInState = .signOut
            // TODO: Cancel Fetch
        }
    }
}
