//
//  RootViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

final class RootViewModel: ObservableObject {
    
    enum Attached {
        case signIn(SignInViewModel)
        case torrentList(TorrentListViewModel)
    }
    
    @Published private(set) var attached: Attached?
    private let credentialsValueSubject = CurrentValueSubject<DelugeClient?, Never>(nil)
    private var cancellable: AnyCancellable?
    
    private let store: AppStore
    
    // MARK: - Life Cycle
    
    init(store: AppStore) {
        self.store = store
    }
    
    func setup() {
        
        cancellable = credentialsValueSubject.sink { [unowned self] client in
            
            if client != nil {
                self.attached = .torrentList(.init(store: self.store))
            }
            else {
                self.attached = .signIn(.init(credentialsValueSubject: self.credentialsValueSubject))
            }
        }
    }
}
