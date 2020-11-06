//
//  SelectTabAction.swift
//  Deluge
//
//  Created by Emil Landron on 5/22/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import SwiftyRedux

struct SelectTabAction: Action {
    
    let tab: Int
    
    var reducer: AnyReducer<AppState, AppEnvironment> {

        SyncReducer<AppState, AppEnvironment> { state, _ in
            state.selectedTab = self.tab
        }
    }
}
