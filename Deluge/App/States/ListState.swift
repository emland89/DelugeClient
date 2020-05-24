//
//  ListState.swift
//  Deluge
//
//  Created by Emil Landron on 5/23/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

struct ListState {
    
    enum Filter: CaseIterable, Identifiable {
        
        var id: Self { self }
        case downloading
        case seeding
        case queued
        case paused
    }
    
    let filters = Filter.allCases
    
    var selectedFilter: Filter = .downloading
    var torrents: [Torrent] = []
    var fetchCancellable: AnyCancellable?

    var filteredTorrents: [Torrent] {
        
        torrents.filter { torrent in
            
            switch selectedFilter {
            case .downloading:
                return torrent.state == .downloading
                
            case .seeding:
                return torrent.state == .seeding
                
            case .queued:
                return torrent.state == .queued
                
            case .paused:
                return torrent.state == .paused
            }
        }
        .sorted { ($0.queue == -1 ? Int.max : $0.queue, $0.name) < ($1.queue == -1 ? Int.max : $1.queue, $1.name) }
    }
}
