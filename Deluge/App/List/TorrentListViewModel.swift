//
//  TorrentListViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

final class TorrentListViewModel: ObservableObject {
    
    // MARK: - Types
    
    enum Filter: CaseIterable, Identifiable {
        
        var id: Self { self }
        
        case all
        case downloading
        case seeding
        case queued
    }
    
    // MARK: - Properties

    @Published var selectedFilter: Filter = .all
    @Published private var unfilteredTorrents: [TorrentListItem] = []
    
    let filters = Filter.allCases
    private let service: TorrentListService
    private var fetchCancellable: AnyCancellable?
    private var timerCancellable: AnyCancellable?

    var torrents: [TorrentListItem] {
        
        unfilteredTorrents.filter { torrent in
            
            switch selectedFilter {
            case .all:
                return true
                
            case .downloading:
                return torrent.state == .downloading
                
            case .seeding:
                return torrent.state == .seeding
                
            case .queued:
                return torrent.state == .queued
            }
        }
        .sorted { ($0.queue == -1 ? Int.max : $0.queue, $0.name) < ($1.queue == -1 ? Int.max : $1.queue, $1.name) }
    }
    
    // MARK: - Life Cycle

    init(credentials: Credentials) {
        service = TorrentListService(credentials: credentials)
    }
    
    func setup() {
        timerCancellable = Timer.publish(every: 1.0, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink { receivedTimeStamp in
                self.fetch()
        }
    }
    
    // MARK: - Actions

    func top(_ torrents: TorrentListItem...) {
        
    }
    
    func up(_ torrent: TorrentListItem...) {
        
    }
    
    func down(_ torrent: TorrentListItem...) {
        
    }
    
    func bottom(_ torrent: TorrentListItem...) {
        
    }
    
    // MARK: - Helpers

    private func fetch() {
        
        fetchCancellable = service.fetchPublisher()
            .receive(on: RunLoop.main)
            .replaceError(with: unfilteredTorrents)
            .assign(to: \.unfilteredTorrents, on: self)
    }
}
