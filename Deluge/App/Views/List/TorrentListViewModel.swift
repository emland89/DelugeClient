//
//  TorrentListViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

final class TorrentListViewModel: ViewModel {
    
    // MARK: - Types
    
    enum Filter: CaseIterable, Identifiable {
        
        var id: Self { self }
        case downloading
        case seeding
        case queued
        case paused
    }
    
    // MARK: - Properties
    

    @Published var selectedFilter: Filter = .downloading
    var cancellable: AnyCancellable?

    let filters = Filter.allCases
    
    var torrents: [Torrent] {
        
        store.state.torrents.filter { torrent in
            
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
    
    // MARK: - Life Cycle


    
    func setup() {
        store.send(StartFetchTorrentsAction())
    }
    
    // MARK: - Actions

    func resume(_ torrents: Torrent...) {
       // execute(.resume, for: torrents)
    }
    
    func pause(_ torrents: Torrent...) {
        //execute(.pause, for: torrents)
    }
    
    func top(_ torrents: Torrent...) {
        //execute(.top, for: torrents)
    }
    
    func up(_ torrents: Torrent...) {
        //execute(.up, for: torrents)
    }
    
    func down(_ torrents: Torrent...) {
        //execute(.down, for: torrents)
    }
    
    func bottom(_ torrents: Torrent...) {
        //execute(.bottom, for: torrents)
    }

}
