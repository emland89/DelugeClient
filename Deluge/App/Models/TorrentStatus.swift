//
//  Torrent.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation

enum TorrentState: String, Codable {
    
    var id: TorrentState { self }
    
    case downloading = "Downloading"
    case queued = "Queued"
    case seeding = "Seeding"
}

struct TorrentListItem: Decodable, Identifiable, Hashable {
    

    var id: String { hash }
    let eta: TimeInterval
    let queue: Int
    let state: TorrentState
    let hash: String
    let progress: Double
    let name: String
    let uploadPayloadRate: Int
    let downloadPayloadRate: Int
    let label: String?
}
