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
    
    enum Filter: CaseIterable, Identifiable {
        
        var id: Self { self }
        
        case all
        case downloading
        case seeding
        case queued
    }
    
    @Published var selectedFilter: Filter = .all
    @Published private var unfilteredTorrents: [TorrentStatus] = []
    
    let filters = Filter.allCases
    private let service: TorrentListService
    private var fetchCancellable: AnyCancellable?
    private var timerCancellable: AnyCancellable?

    var torrents: [TorrentStatus] {
        
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
    
    private func fetch() {
        
        fetchCancellable = service.fetchPublisher()
            .receive(on: RunLoop.main)
            .replaceError(with: unfilteredTorrents)
            .assign(to: \.unfilteredTorrents, on: self)
    }
}
