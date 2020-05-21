//
//  PreviewProvider+Utilities.swift
//  Deluge
//
//  Created by Emil Landron on 5/21/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

extension PreviewProvider {
    
    static var store: AppStore {
        (UIApplication.shared.delegate as! AppDelegate).store
    }
}
