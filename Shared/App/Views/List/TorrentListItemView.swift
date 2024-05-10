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

    private var percent: Double {
        torrent.progress / 100
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text(torrent.name.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.footnote)
                .lineLimit(2)

            ProgressView(value: percent)

            HStack {

                Text(queuePriority)
                    .frame(minWidth: 22, alignment: .leading)

                TransferRateView(
                    uploadRate: torrent.uploadPayloadRate,
                    downloadRate: torrent.downloadPayloadRate
                )

                Spacer()

                ETAView(eta: torrent.eta)

                Text(percent, format: .percent.precision(.fractionLength(2)))
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }

    private var queuePriority: String {
        torrent.queue >= 0 ? "\(torrent.queue + 1)" : "-"
    }
}

#Preview {

    let torrent1 = Torrent(
        id: "1",
        eta: 60,
        queue: 1,
        state: .downloading,
        progress: 20,
        name: "Name",
        uploadPayloadRate: 31,
        downloadPayloadRate: 14,
        label: "tv"
    )

    let torrent2 = Torrent(
        id: "2",
        eta: 60,
        queue: -1,
        state: .downloading,
        progress: 70,
        name: "Name",
        uploadPayloadRate: 31,
        downloadPayloadRate: 14,
        label: "tv"
    )

    let torrent3 = Torrent(
        id: "3",
        eta: 3200,
        queue: 99,
        state: .downloading,
        progress: 55,
        name: "Name",
        uploadPayloadRate: 31,
        downloadPayloadRate: 14,
        label: "tv"
    )

    return List {
        TorrentListItemView(torrent: torrent1)
        TorrentListItemView(torrent: torrent2)
        TorrentListItemView(torrent: torrent3)
    }
}
