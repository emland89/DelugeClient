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
    
    func reducer(environment: AppEnvironment) -> Reducer<AppState> {
        
        Reducer {
            SyncReducer { state in
                state.selectedTab = self.tab
            }
        }
    }
}
