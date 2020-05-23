//
//  TorrentQueueAction.swift
//  Deluge
//
//  Created by Emil Landron on 5/21/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine
import SwiftyRedux

struct TorrentQueueAction: Action {
    
    enum Action {
        case resume, pause, top, up, down, bottom
    }
    
    let action: Action
    let torrents: [Torrent]
    
    func reducer(environment: AppEnvironment) -> Reducer<AppState> {
        
        Reducer<State>(async: { state -> AnyPublisher<Void, Never> in
            guard let session = state.signInState.session else {
                return Empty<Void, Never>().eraseToAnyPublisher()
            }
            
            return environment
                .delugeClient
                .actionPublisher(endpoint: session.endpoint, action: self.action.delugeAction, for: self.torrents)
                .replaceError(with: ())
                .eraseToAnyPublisher()
        })
        
    }
}

private extension TorrentQueueAction.Action {
    
    var delugeAction: DelugeClient.Action {
        switch self {
        case .resume:
            return .resume
        case .pause:
            return .pause
            
        case .top:
            return .top
            
        case .up:
            return .up
            
        case .down:
            return .down
            
        case .bottom:
            return .bottom
        }
    }
    
}
