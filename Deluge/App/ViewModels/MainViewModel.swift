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

    init(client: DelugeClient) {
        listViewModel = .init(client: client)
    }
}
