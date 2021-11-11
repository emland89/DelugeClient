//
//  TorrentListViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 11/10/21.
//  Copyright © 2021 Emil Landron. All rights reserved.
//

import Foundation

@MainActor
final class TorrentListViewModel: ObservableObject {

    
    @Published private(set) var torrents: [Torrent] = []
    
    private let client: DelugeClient
    private var task: Task<Void, Error>?

    
    init(client: DelugeClient) {
        self.client = client
        
        task = Task<Void, Error>(priority: .background) {
            
            let stream = AsyncThrowingStream { [client] in
                try await client.allTorrents()
            }
            
            for try await torrents in stream {
                self.torrents = torrents
            }
        }
    }
    
    deinit {
        task?.cancel()
    }
    
    func perform(action: DelugeClient.Action, for torrents: [Torrent]) async {
        do {
            try await client.perform(action: action, for: torrents)
        }
        catch {
            print(error)
            // Alert
        }
    }
}
