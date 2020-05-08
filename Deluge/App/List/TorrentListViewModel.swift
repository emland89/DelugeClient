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
        case downloading
        case seeding
        case queued
        case paused
    }
    
    // MARK: - Properties

    @Published var selectedFilter: Filter = .downloading
    @Published private var unfilteredTorrents: [Torrent] = []
    
    let filters = Filter.allCases
    private let client: DelugeClient
    private var fetchCancellable: AnyCancellable?
    private var timerCancellable: AnyCancellable?

    var cancellables: [AnyCancellable] = []
    
    var torrents: [Torrent] {
        
        unfilteredTorrents.filter { torrent in
            
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

    init(client: DelugeClient) {
        self.client = client
    }
    
    func setup() {
        timerCancellable = Timer.publish(every: 1.0, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink { receivedTimeStamp in
                self.fetch()
        }
    }
    
    // MARK: - Actions

    func resume(_ torrents: Torrent...) {
        execute(.resume, for: torrents)
    }
    
    func pause(_ torrents: Torrent...) {
        execute(.pause, for: torrents)
    }
    
    
    func top(_ torrents: Torrent...) {
        execute(.top, for: torrents)
    }
    
    func up(_ torrents: Torrent...) {
        execute(.up, for: torrents)

    }
    
    func down(_ torrents: Torrent...) {
        execute(.down, for: torrents)
    }
    
    func bottom(_ torrents: Torrent...) {
        execute(.bottom, for: torrents)
    }

    private func execute(_ action: DelugeClient.Action, for torrents: [Torrent]) {
        client.actionPublisher(action, for: torrents).sink(receiveCompletion: { _ in }, receiveValue: {} ).store(in: &cancellables)
    }
    
    // MARK: - Helpers

    private func fetch() {
        
        client.fetchAllPublisher()
            .receive(on: RunLoop.main)
            .replaceError(with: unfilteredTorrents)
            .assign(to: \.unfilteredTorrents, on: self)
            .store(in: &cancellables)
    }
}
