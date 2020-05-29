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
    
    // MARK: - Types
    
    enum ClientError: Error {
        case server(ServerError)
        case parsing(Error)
        case other(Error)
    }
    
    struct ServerError: Error, Decodable {
        let code: Int
        let message: String
    }
    
    enum Action: String {
        case resume = "core.resume_torrent"
        case pause = "core.pause_torrent"
        case top = "core.queue_top"
        case up = "core.queue_up"
        case down = "core.queue_down"
        case bottom = "core.queue_bottom"
    }
    
    private struct Response<Value: Decodable>: Decodable {
        let result: Value?
        let error: ServerError?
    }
    
    private struct RequestBody<P: Encodable>: Encodable {
        let id = Int.random(in: 0...Int.max)
        let method: String
        let params: [P]
    }
    
    private struct EmptyResponseBody: Decodable { }

    
    // MARK: - Actions

    
    func authenticatePublisher(endpoint: URL, password: String) -> AnyPublisher<Bool, ClientError> {
        let body = RequestBody(method: "auth.login", params: [password])
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: Bool.self)
    }
    
    func addMagnetPublisher(url: URL) -> AnyPublisher<Void, Swift.Error> {
        fatalError()
    }

    func fetchAllPublisher(endpoint: URL) -> AnyPublisher<[Torrent], ClientError> {
        let fields = ["queue", "name", "hash", "upload_payload_rate", "download_payload_rate", "progress", "state", "label", "eta"]
        let body = RequestBody(method: "core.get_torrents_status", params: [[], fields])
        
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: [String: Torrent].self)
        .map { Array($0.values) }
        .eraseToAnyPublisher()
    }
    
    func actionPublisher(endpoint: URL, action: Action, for torrents: [Torrent]) -> AnyPublisher<Void, ClientError> {
                
        let hashes = torrents.map { $0.hash }
        let body = RequestBody(method: action.rawValue, params: [hashes])
        
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: EmptyResponseBody.self)
        .map { _ in }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Helpers
    
    private func dataTaskPublisher<D: Decodable, P: Encodable>(endpoint: URL, body: RequestBody<P>, decodingType: D.Type) -> AnyPublisher<D, ClientError> {
        
        var request = URLRequest(url: endpoint.appendingPathComponent("json"))
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: request).mapError { error in
            ClientError.parsing(error)
        }
        .map { $0.data }
        .decode(type: Response<D>.self, decoder: decoder)
        .mapError { error in
            ClientError.parsing(error)
        }
        .tryMap { response in
            if let result = response.result {
                return result
            }
            else if let error = response.error {
                throw error
            }
            fatalError()
        }
        .mapError { error in
            ClientError.server(error as! DelugeClient.ServerError)
        }
        .eraseToAnyPublisher()
    }
}
