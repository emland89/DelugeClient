//
//  Session.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation

struct Session: Codable {
    let endpoint: URL
    let password: String
}
