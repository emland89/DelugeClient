//
//  RootViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 11/10/21.
//  Copyright © 2021 Emil Landron. All rights reserved.
//

import Foundation

@MainActor
final class RootViewModel: ObservableObject {
    
    enum Attached {
        case signIn(SignInViewModel)
        case main(MainViewModel)
    }
    
    @Published private(set) var attached: Attached?
    
    init() {
        // TODO: Check password and user
        
        Task {
            let viewModel = SignInViewModel()
            attached = .signIn(viewModel)
            
            let client = await viewModel.client()
            attached = .main(.init(client: client))
        }
    }
}
