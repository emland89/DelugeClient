//
//  MainViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 11/11/21.
//  Copyright © 2021 Emil Landron. All rights reserved.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    
    let listViewModel: TorrentListViewModel
    private let client: DelugeClient

    init(client: DelugeClient) {
        self.client = client
        listViewModel = .init(client: client)
    }
    
    func addMagnet(link: URL) {
        Task {
            try await client.addMagnet(link: link)
        }
    }
}
