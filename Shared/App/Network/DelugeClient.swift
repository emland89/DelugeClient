//
//  DelugeService.swift
//  Deluge
//
//  Created by Emil Landron on 5/8/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation

final class DelugeClient {
    
    // MARK: - Types
    
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
    
    private let endpoint: URL
    private let password: String
    private var task: Task<Void, Error>?

    private var isConnected: Bool {
        get async throws {
            let body = RequestBody(method: "web.connected", params: [String]())
            return try await send(body: body, responseType: Bool.self)
        }
    }
    
    var torrents: AsyncThrowingStream<[Torrent], Error> {
        
        AsyncThrowingStream<[Torrent], Error> { [self] in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            let fields = ["queue", "name", "hash", "upload_payload_rate", "download_payload_rate", "progress", "state", "label", "eta"]
            let body = RequestBody(method: "core.get_torrents_status", params: [], fields)
            
            let values = try await send(body: body, responseType: [String: Torrent].self).values
            return Array(values)
        }
    }
    
    init(endpoint: URL, password: String) {
        self.endpoint = endpoint
        self.password = password
    }
    
    deinit {
        task?.cancel()
    }
    
    // MARK - Methods
    
    /// Host id
    func login() async throws {
        let body = RequestBody(method: "auth.login", params: password)
        try await send(body: body, responseType: Bool.self)
        
        keepAlive()
    }
    
    /// Adds a magnet link
    /// - Parameter link: The torrent link to add
    /// - Returns: The added torrent id
    func addMagnet(link: URL) async throws -> String {
        
        let body = RequestBody(method: "core.add_torrent_magnet", params: link, nil)
        return try await send(body: body, responseType: String.self)
    }
    
//    func prefetchMagnetMetadata(link: URL) async throws -> [String: String] {
//        let body = RequestBody(method: "core.prefetch_magnet_metadata", params: link, nil)
//        return try await send(body: body, responseType: [String: String].self)
//    }
    
    func perform(action: Action, for torrents: [Torrent]) async throws {
        let hashes = torrents.map { $0.hash }
        let body = RequestBody(method: action.rawValue, params: hashes)
        
        try await send(body: body, responseType: EmptyResponseBody.self)
    }
    
    func remove(torrent: Torrent) async throws {
        let body = RequestBody(method: "core.remove_torrent", params: torrent.id, "TRUE")
        let success = try await send(body: body, responseType: Bool.self)
        print(#function, success)
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
            throw error
        }
        else {
            throw ServerError(code: -1, message: "Response is empty")
        }
    }
    
    private func keepAlive() {

        task = Task<Void, Error>(priority: .background) { [self] in
            
            try Task.checkCancellation()

            if try await isConnected {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                keepAlive()
            }
            else {
                try await login() // TODO: Sign Out
                keepAlive()
            }
        }
    }
}
