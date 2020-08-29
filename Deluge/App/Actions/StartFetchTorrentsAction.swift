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
                
        Reducer(components: {
            
            AsyncReducer(publisher: { state in
                self.fetchPublisherFor(state: state, client: environment.delugeClient)
                
            }, cancellation: { state, cancellable in
                state.list.fetchCancellable?.cancel()
                state.list.fetchCancellable = cancellable
                
            }, result: { state, torrents in
                state.list.torrents = torrents
                
            }, catch: { state, error in
                print(error)
                guard let session = state.session.signInState.session else {
                    state.session.signInState = .signOut
                    return nil
                }
                
                return SignInAction(session: session).reducer(environment: environment)
            })
        })
    }
    
    func fetchPublisherFor(state: AppState, client: DelugeClient) -> AnyPublisher<[Torrent], DelugeClient.Error> {
        
        Timer.publish(every: 1, on: RunLoop.current, in: .default)
        .autoconnect()
        .compactMap { _ in state.session.signInState.session }
        .setFailureType(to: DelugeClient.Error.self)
        .flatMap { session in
            client.fetchAllPublisher(endpoint: session.endpoint)
        }
        .eraseToAnyPublisher()
    }
}
