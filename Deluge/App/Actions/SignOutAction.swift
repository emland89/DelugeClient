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
    
    var reducer: AnyReducer<AppState, AppEnvironment> {
        
        SyncReducer<AppState, Environment> { state, _ in
            state.selectedTab = 0
            state.session.signInState = .signOut
            state.list.fetchCancellable?.cancel()
        }
    }
}
