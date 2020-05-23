//
//  Delugeclient.swift
//  Deluge
//
//  Created by Emil Landron on 5/8/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

final class DelugeClient {
    
    enum Action: String {
        case resume = "core.resume_torrent"
        case pause = "core.pause_torrent"
        case top = "core.queue_top"
        case up = "core.queue_up"
        case down = "core.queue_down"
        case bottom = "core.queue_bottom"
    }
    
    private struct RequestBody<P: Encodable>: Encodable {
        let id = Int.random(in: 0...Int.max)
        let method: String
        let params: [P]
    }
             
    
    // MARK: - Actions

    
    func authenticatePublisher(endpoint: URL, password: String) -> AnyPublisher<Void, Swift.Error> {
        
        enum Error: Swift.Error {
            case invalidSession(URL)
            case connection(Swift.Error)
        }
        
        struct Response: Decodable {
            let result: Bool
        }
        
        let body = RequestBody(method: "auth.login", params: [password])
        
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: Response.self)
            .tryMap { response in
                guard !response.result else { return }
                throw Error.invalidSession(endpoint)
        }
        .eraseToAnyPublisher()
    }
    
    
    func addMagnetPublisher(url: URL) -> AnyPublisher<Void, Swift.Error> {
        fatalError()
    }

    func fetchAllPublisher(endpoint: URL) -> AnyPublisher<[Torrent], Swift.Error> {
        
        struct Response: Decodable {
            
            private enum CodingKeys: String, CodingKey {
                case result
            }
            
            let result: [Torrent]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let decoded = try container.decode([String: Torrent].self, forKey: .result)
                result = decoded.map { $0.value }
            }
        }
        
        let fields = ["queue", "name", "hash", "upload_payload_rate", "download_payload_rate", "progress", "state", "label", "eta"]
        let body = RequestBody(method: "core.get_torrents_status", params: [[], fields])
        
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: Response.self)
            .map { $0.result}
            .eraseToAnyPublisher()
    }
    
    func actionPublisher(endpoint: URL, action: Action, for torrents: [Torrent]) -> AnyPublisher<Void, Swift.Error> {
        
        // TODO: Check for error
        struct Response: Decodable { }
        
        let hashes = torrents.map { $0.hash }
        let body = RequestBody(method: action.rawValue, params: [hashes])
        
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: Response.self)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helpers
    
    private func dataTaskPublisher<D: Decodable, P: Encodable>(endpoint: URL, body: RequestBody<P>, decodingType: D.Type) -> AnyPublisher<D, Error> {
        
        var request = URLRequest(url: endpoint.appendingPathComponent("json"))
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

