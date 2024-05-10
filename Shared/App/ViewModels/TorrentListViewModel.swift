//
//  TorrentListViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 11/10/21.
//  Copyright © 2021 Emil Landron. All rights reserved.
//

import Foundation

@Observable
final class TorrentListViewModel {

    private(set) var torrents: [Torrent] = []
    
    private let client: DelugeClient
    private var task: Task<Void, Error>?

    init(client: DelugeClient) {
        self.client = client
        
        task = Task<Void, Error>(priority: .background) {
            for try await torrents in client.torrents {
                self.torrents = torrents
            }
        }
    }
    
    deinit {
        task?.cancel()
    }
    
    func perform(action: DelugeClient.Action, for torrents: Torrent...) {
        Task {
            do {
                try await client.perform(action: action, for: torrents)
            }
            catch {
                // TODO: Show Error Alert
                print(error)
            }
        }
    }
    
    func remove(torrents: [Torrent]) {
        Task {
            await withThrowingTaskGroup(of: Void.self) { [client] group in
                torrents.forEach { torrent in
                    group.addTask {
                        try await client.remove(torrent: torrent)
                    }
                }
            }
        }
    }
}
