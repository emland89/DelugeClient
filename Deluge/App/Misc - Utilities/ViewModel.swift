//
//  ViewModel.swift
//  Deluge
//
//  Created by Emil Landron on 5/21/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    let store: AppStore
    private var cancellable: AnyCancellable?
    
    init(store: AppStore) {
        self.store = store
        
        cancellable = store.$state.sink { _ in
            self.objectWillChange.send()
        }
    }
}
