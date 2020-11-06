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
    
    var reducer: AnyReducer<AppState, AppEnvironment> {

        AsyncReducer<AppState, AppEnvironment, Void, DelugeClient.Error> { state, environment in
            Just(state.session.signInState.session)
                .compactMap { $0 }
                .setFailureType(to: DelugeClient.Error.self)
                .flatMap { session in
                    environment.delugeClient.actionPublisher(endpoint: session.endpoint, action: self.action.delugeAction, for: self.torrents)
                }
                .eraseToAnyPublisher()
        }
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
