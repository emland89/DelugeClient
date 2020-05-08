//
//  TorrentListService.swift
//  Deluge
//
//  Created by Emil Landron on 5/7/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import Foundation
import Combine

struct TorrentListService {
    
    // MARK: - Types
    
    private struct Response: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case result
        }
        
        let result: [TorrentStatus]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let decoded = try container.decode([String: TorrentStatus].self, forKey: .result)
            result = decoded.map { $0.value }
        }
    }
    
    // MARK: - Properties
    
    let credentials: Credentials
    
    // MARK: - Methods
    
    func fetchPublisher() -> AnyPublisher<[TorrentStatus], Swift.Error> {
        
        let body = RequestBody(
            method: "core.get_torrents_status",
            params: [[], [
                "queue",
                "name",
                "hash",
                "upload_payload_rate",
                "download_payload_rate",
                "progress",
                "state",
                "label",
                "eta",
            ]]
        )
        
        return URLSession.shared.dataTaskPublisher(credentials: credentials, body: body, decodingType: Response.self)
            .map { $0.result}
            .eraseToAnyPublisher()
    }
}

