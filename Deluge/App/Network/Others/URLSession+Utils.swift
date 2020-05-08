//
//  URLSession+Utils.swift
//  Deluge
//
//  Created by Emil Landron on 5/7/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

extension URLSession {
    
    func dataTaskPublisher<D: Decodable, P: Encodable>(credentials: Credentials, body: RequestBody<P>, decodingType: D.Type) -> AnyPublisher<D, Error> {
        
        var request = URLRequest(url: credentials.endpoint.appendingPathComponent("json"))
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: decodingType, decoder: decoder)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .eraseToAnyPublisher()
    }
}
