//
//  AppState.swift
//  Deluge
//
//  Created by Emil Landron on 5/18/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation

struct AppState {
    
    var selectedTab = 0
    
    var list = ListState()
    var session = SessionState()
}
