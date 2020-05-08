//
//  TorrentListItemView.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct TorrentListItemView: View {
    
    let torrent: Torrent
    
    private var percent: Double { torrent.progress / 100 }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            Text(self.torrent.name.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.footnote)
                .lineLimit(2)
            
            ProgressBar(value: .constant(percent))
                .frame(height: 3)
            
            HStack {
                Text(queue)
                    .frame(minWidth: 22, alignment: .leading)
                
                UploadDownloadView(
                    uploadRate: .constant(torrent.uploadPayloadRate),
                    downloadRate: .constant(torrent.downloadPayloadRate)
                )
                
                Spacer()
                
                ETAView(eta: .constant(self.torrent.eta))
                
                PercentView(percent: .constant(percent))
                    .frame(minWidth: 22, alignment: .trailing)
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

        let torrent1 = Torrent(
            eta: 60,
            queue: 1,
            state: .downloading,
            hash: "aas",
            progress: 20,
            name: "Name",
            uploadPayloadRate: 31,
            downloadPayloadRate: 14,
            label: "tv"
        )
        
        let torrent2 = Torrent(
            eta: 60,
            queue: -1,
            state: .downloading,
            hash: "aas",
            progress: 70,
            name: "Name",
            uploadPayloadRate: 31,
            downloadPayloadRate: 14,
            label: "tv"
        )
        
        let torrent3 = Torrent(
            eta: 60,
            queue: 99,
            state: .downloading,
            hash: "aas",
            progress: 55,
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
