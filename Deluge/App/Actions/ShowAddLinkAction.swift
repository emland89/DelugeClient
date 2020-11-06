//
//  ShowAddLinkAction.swift
//  ShowAddLinkAction
//
//  Created by Emil Landron on 9/8/21.
//  Copyright © 2021 Emil Landron. All rights reserved.
//

import Foundation
import Combine
import SwiftyRedux


struct ShowAddLinkAction: Action {
    
    let link: URL
    
    var reducer: AnyReducer<AppState, AppEnvironment> {
        
        AsyncReducer<AppState, AppEnvironment, String, DelugeClient.Error> { state, environment in
            
            Just(state.session.signInState.session)
                .compactMap { $0 }
                .setFailureType(to: DelugeClient.Error.self)
                .flatMap { session in
                    // TODO: Show an actual screen
                    environment.delugeClient.addMagnetPublisher(endpoint: session.endpoint, link: link)
                }
                .eraseToAnyPublisher()
        }
    }
}
