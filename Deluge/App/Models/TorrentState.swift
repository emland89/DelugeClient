//
//  TorrentState.swift
//  Deluge
//
//  Created by Emil Landron on 5/8/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation

enum TorrentState: String, Codable, Identifiable, CaseIterable {
    
    var id: TorrentState { self }
    
    case downloading = "Downloading"
    case queued = "Queued"
    case seeding = "Seeding"
    case paused = "Paused"
    case error = "Error"
}
