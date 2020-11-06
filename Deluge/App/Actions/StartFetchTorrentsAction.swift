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
    
    var reducer: AnyReducer<AppState, AppEnvironment> {

        AsyncReducer<AppState, AppEnvironment, [Torrent], DelugeClient.Error> { state, environment in
            self.fetchPublisherFor(state: state, client: environment.delugeClient)
        } subscription: { state, cancellable in
            state.list.fetchCancellable?.cancel()
            state.list.fetchCancellable = cancellable
            
        } result: { state, _, torrents in
            state.list.torrents = torrents
            
        } catch: { state, store, error in
            print(error)
            
            if let session = state.session.signInState.session {
                store.send(SignInAction(session: session))
            } else {
                state.session.signInState = .signOut

            }
            
        }
    }
    
    func fetchPublisherFor(state: AppState, client: DelugeClient) -> AnyPublisher<[Torrent], DelugeClient.Error> {
        
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .compactMap { _ in state.session.signInState.session }
            .setFailureType(to: DelugeClient.Error.self)
            .flatMap { session in
                client
                    .fetchAllPublisher(endpoint: session.endpoint)
                    .receive(on: DispatchQueue.main)
            }
            .eraseToAnyPublisher()
    }
}
