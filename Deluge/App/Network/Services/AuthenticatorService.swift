//
//  AuthenticatorService.swift
//  Deluge
//
//  Created by Emil Landron on 5/7/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

struct Authenticator {
    
    // MARK: - Types
    
    enum Error: Swift.Error {
        case invalidCredentials(Credentials)
        case connection(Swift.Error)
    }
    
    private struct Response: Decodable {
        let result: Bool
    }
    
    // MARK: - Properties

    let credentials: Credentials
    
    // MARK: - Methods

    func fetchPublisher() -> AnyPublisher<Void, Swift.Error> {
        
        let body = RequestBody(method: "auth.login", params: [credentials.password])
        
        return URLSession.shared.dataTaskPublisher(credentials: credentials, body: body, decodingType: Response.self)
            .tryMap { response in
                guard !response.result else { return }
                throw Error.invalidCredentials(self.credentials)
            }
            .eraseToAnyPublisher()
    }
}


