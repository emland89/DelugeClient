//
//  AppState.swift
//  Deluge
//
//  Created by Emil Landron on 5/18/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation

struct AppState {
    
    var credentials: Credentials? = nil
    
    var torrents: [Torrent] = []
    
    var isSyncing = false
}
