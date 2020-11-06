//
//  ChangeFilterAction.swift
//  Deluge
//
//  Created by Emil Landron on 5/21/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import SwiftyRedux

struct ChangeFilterAction: Action {
    
    let filter: ListState.Filter
    
    var reducer: AnyReducer<AppState, AppEnvironment> {
        SyncReducer<AppState, AppEnvironment> { state, _ in
            state.list.selectedFilter = filter
        }
    }
}
