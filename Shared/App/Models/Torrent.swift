//
//  Torrent.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation

struct Torrent: Decodable, Identifiable, Hashable {
    
    private enum CodingKeys: String, CodingKey {
        case id = "hash"
        case eta
        case queue
        case state
        case progress
        case name
        case uploadPayloadRate
        case downloadPayloadRate
        case label
    }

    let id: String
    let eta: TimeInterval
    let queue: Int
    let state: TorrentState
    let progress: Double
    let name: String
    let uploadPayloadRate: Int
    let downloadPayloadRate: Int
    let label: String?
}
