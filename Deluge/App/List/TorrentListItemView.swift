//
//  TorrentListItemView.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct TorrentListItemView: View {
    
    let torrent: TorrentStatus
    
    var body: some View {
                 
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(self.torrent.name.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(.footnote)
                    .lineLimit(2)
                
                ProgressBar(value: .constant(torrent.progress))
                    .frame(height: 3)
                
                HStack {
                    Text(queue)
                        .frame(minWidth: 28, alignment: .leading)
                    
                    UploadDownloadView(
                        uploadRate: .constant(torrent.uploadPayloadRate),
                        downloadRate: .constant(torrent.downloadPayloadRate)
                    )
                    
                    Spacer()
                    
                    ETAView(eta: .constant(self.torrent.eta))
                }
                .font(.caption)
                .foregroundColor(.secondary)

        }
    }
    
    private var queue: String {
        torrent.queue >= 0 ? "\(torrent.queue + 1)" : "-"
    }
}

struct TorrentListItemView_Previews: PreviewProvider {

    static var previews: some View {

        let torrent1 = TorrentStatus(
            eta: 60,
            queue: 1,
            state: .downloading,
            hash: "aas",
            progress: 0.6,
            name: "Name",
            uploadPayloadRate: 31,
            downloadPayloadRate: 14,
            label: "tv"
        )
        
        let torrent2 = TorrentStatus(
            eta: 60,
            queue: -1,
            state: .downloading,
            hash: "aas",
            progress: 0.6,
            name: "Name",
            uploadPayloadRate: 31,
            downloadPayloadRate: 14,
            label: "tv"
        )
        
        let torrent3 = TorrentStatus(
            eta: 60,
            queue: 99,
            state: .downloading,
            hash: "aas",
            progress: 0.6,
            name: "Name",
            uploadPayloadRate: 31,
            downloadPayloadRate: 14,
            label: "tv"
        )
        
        return Group {
            TorrentListItemView(torrent: torrent1)
            TorrentListItemView(torrent: torrent2)
            TorrentListItemView(torrent: torrent3)

        }
        .previewLayout(.sizeThatFits)
    }
}
