//
//  RequestBody.swift
//  Deluge
//
//  Created by Emil Landron on 5/7/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation

struct RequestBody<P: Encodable>: Encodable {
    
    let id = Int.random(in: 0...Int.max)
    let method: String
    let params: [P]
}
