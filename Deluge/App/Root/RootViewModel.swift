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
    private let credentialsValueSubject = CurrentValueSubject<Credentials?, Never>(nil)
    private var cancellable: AnyCancellable?
    
    func setup() {
        
        cancellable = credentialsValueSubject.sink { [unowned self] credentials in
            
            if let credentials = credentials {
                self.attached = .torrentList(.init(credentials: credentials))
            }
            else {
                self.attached = .signIn(.init(credentialsValueSubject: self.credentialsValueSubject))
            }
        }
    }
}