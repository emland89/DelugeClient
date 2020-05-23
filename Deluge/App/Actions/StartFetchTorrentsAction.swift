//
//  StartFetchTorrentsAction.swift
//  Deluge
//
//  Created by Emil Landron on 5/18/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine
import SwiftyRedux

struct StartFetchTorrentsAction: Action {
    
    func reducer(environment: AppEnvironment) -> Reducer<AppState> {
                
        Reducer<AppState>(value: { state  in
            self.fetchPublisherFor(state: state, client: environment.delugeClient)
        }, final: { state, torrents in
            state.torrents = torrents
        })
    }
    
    func fetchPublisherFor(state: AppState, client: DelugeClient) -> AnyPublisher<[Torrent], Never> {
        
        Timer.publish(every: 1, on: RunLoop.current, in: .default).autoconnect().flatMap { _ -> AnyPublisher<[Torrent], Never>  in
            
            guard let session = state.signInState.session else {
                return Empty<[Torrent], Never>().eraseToAnyPublisher()
            }
            
            return client
                .fetchAllPublisher(endpoint: session.endpoint)
                .catch { error -> Empty<[Torrent], Never>in
                    print(error)
                    return Empty<[Torrent], Never>()
                    
                }
                .eraseToAnyPublisher()
        }
       .eraseToAnyPublisher()
    }
}
