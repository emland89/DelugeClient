//
//  RootViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 11/10/21.
//  Copyright © 2021 Emil Landron. All rights reserved.
//

import Foundation

@Observable
final class RootViewModel {
    
    enum Attached {
        case signIn(SignInViewModel)
        case main(MainViewModel)
    }
    
    private(set) var attached: Attached?

    init() {
        // TODO: Check password and user on keychain

        let viewModel = SignInViewModel { [weak self] client in
            self?.attached = .main(.init(client: client))
        }

        attached = .signIn(viewModel)
    }
}
