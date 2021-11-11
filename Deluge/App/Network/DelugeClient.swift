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
    
    enum Error: Swift.Error {
        case server(ServerError)
        case parsing(Swift.Error)
        case network(Swift.Error)
    }
    
    struct ServerError: Swift.Error, Decodable {
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
        
        init(method: String, params: P...) {
            self.method = method
            self.params = params
        }
    }
    
    private struct EmptyResponseBody: Decodable { }
    
    
    let endpoint: URL
    let password: String
    
    init(endpoint: URL, password: String) {
        self.endpoint = endpoint
        self.password = password
    }
    
    // MARK: - Actions
    
    func authenticatePublisher(endpoint: URL, password: String) -> AnyPublisher<Bool, Error> {
        let body = RequestBody(method: "auth.login", params: password)
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: Bool.self)
    }
    
    func addMagnetPublisher(endpoint: URL, link: URL) -> AnyPublisher<String, Error> {
        
        let body = RequestBody(method: "core.add_torrent_magnet", params: link, nil)
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: String.self)
            .eraseToAnyPublisher()
    }
    
    func fetchAllPublisher(endpoint: URL) -> AnyPublisher<[Torrent], Error> {
        let fields = ["queue", "name", "hash", "upload_payload_rate", "download_payload_rate", "progress", "state", "label", "eta"]
        let body = RequestBody(method: "core.get_torrents_status", params: [], fields)
        
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: [String: Torrent].self)
            .map { Array($0.values) }
            .eraseToAnyPublisher()
    }
    
    func actionPublisher(endpoint: URL, action: Action, for torrents: [Torrent]) -> AnyPublisher<Void, Error> {
        
        let hashes = torrents.map { $0.hash }
        let body = RequestBody(method: action.rawValue, params: hashes)
        
        return dataTaskPublisher(endpoint: endpoint, body: body, decodingType: EmptyResponseBody.self)
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
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .mapError { error in
                Error.network(error)
            }
            .map { $0.data }
            .decode(type: Response<D>.self, decoder: decoder)
            .mapError { error in
                Error.parsing(error)
            }
            .tryMap { response in
                if let result = response.result {
                    return result
                }
                else if let error = response.error {
                    throw Error.server(error)
                }
                throw Error.server(DelugeClient.ServerError(code: -1, message: "Response is empty"))
            }
            .mapError { error in
                print(error)
                return error as! Error
                
            }
            .eraseToAnyPublisher()
    }
    
    // MARK - Async
    
    func authenticate() async throws {
        let body = RequestBody(method: "auth.login", params: password)
        let signedIn = try await send(body: body, responseType: Bool.self)
    }
    
    func allTorrents() async throws -> [Torrent] {
        
        let fields = ["queue", "name", "hash", "upload_payload_rate", "download_payload_rate", "progress", "state", "label", "eta"]
        let body = RequestBody(method: "core.get_torrents_status", params: [], fields)
        
        let values = try await send(body: body, responseType: [String: Torrent].self).values
        return Array(values)
    }
    
    func perform(action: Action, for torrents: [Torrent]) async throws {
        
        let hashes = torrents.map { $0.hash }
        let body = RequestBody(method: action.rawValue, params: hashes)
        
        try await send(body: body, responseType: EmptyResponseBody.self)
    }
    
    @discardableResult
    private func send<D: Decodable, P: Encodable>(body: RequestBody<P>, responseType decodingType: D.Type) async throws -> D {
       
        var request = URLRequest(url: endpoint.appendingPathComponent("json"))
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // TODO: check response
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil) // as! (Data, HTTPURLResponse)
        
        let responseBody = try decoder.decode(Response<D>.self, from: data)
        
        if let result = responseBody.result {
            return result
        }
        else if let error = responseBody.error {
            throw Error.server(error)
        }
        
        throw Error.server(DelugeClient.ServerError(code: -1, message: "Response is empty"))
    }
}