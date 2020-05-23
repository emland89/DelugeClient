//
//  AppState.swift
//  Deluge
//
//  Created by Emil Landron on 5/18/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import KeychainStored

struct AppState {
    
    enum Filter: CaseIterable, Identifiable {
        
        var id: Self { self }
        case downloading
        case seeding
        case queued
        case paused
    }
    
    enum SignInState {
        case signout, signingIn, signedIn(Session)
        
        
        var session: Session? {
            guard case .signedIn(let session) = self else { return nil }
            return session
        }
    }
    
    // MARK: - Static Properties
    @KeychainStored(service: "com.deluge.session", encoder: JSONEncoder(), decoder: JSONDecoder()) private static var session: Session?

    // MARK: - Properties

    let filters = Filter.allCases

    var selectedFilter: Filter = .downloading
    var torrents: [Torrent] = []
    
    var signInState: SignInState {
        didSet {
            if case .signedIn(let session) = signInState  {
                Self.session = session
            }
            else {
                Self.session = nil
            }
        }
    }
    
    // MARK: - Computed properties

    
    var filteredTorrents: [Torrent] {
        
        torrents.filter { torrent in
            
            switch selectedFilter {
            case .downloading:
                return torrent.state == .downloading
                
            case .seeding:
                return torrent.state == .seeding
                
            case .queued:
                return torrent.state == .queued
                
            case .paused:
                return torrent.state == .paused
            }
        }
        .sorted { ($0.queue == -1 ? Int.max : $0.queue, $0.name) < ($1.queue == -1 ? Int.max : $1.queue, $1.name) }
    }
    
    init() {
        
        if let session = Self.session {
            signInState = .signedIn(session)
        }
        else {
            signInState = .signout
        }
    }
}
