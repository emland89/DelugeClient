//
//  TorrentsListView.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct TorrentListView: View {
    
    @ObservedObject var viewModel: TorrentListViewModel
    @State private var selectedFilter: TorrentState = .downloading
    
    private var filteredTorrents: [Torrent] {
        viewModel.torrents
            .filter { $0.state == selectedFilter }
            .sorted { ($0.queue == -1 ? Int.max : $0.queue, $0.name) < ($1.queue == -1 ? Int.max : $1.queue, $1.name) }
    }
    
    var body: some View {
        List {
            ForEach(filteredTorrents) { torrent in
                TorrentListItemView(torrent: torrent)
                    .padding(.vertical, 6)
                    .contextMenu {
                        
                        Button("Resume", action: { self.viewModel.perform(action: .resume, for: torrent) })
                        Button("Pause", action: { self.viewModel.perform(action: .pause, for: torrent)})
                        
                        Divider()
                       
                        Button("Top", action: { self.viewModel.perform(action: .top, for: torrent) })
                        Button("Up", action: { self.viewModel.perform(action: .up, for: torrent) })
                        Button("Down", action: { self.viewModel.perform(action: .down, for: torrent) })
                        Button("Bottom", action: { self.viewModel.perform(action: .bottom, for: torrent) })
                    }
            }
            .onDelete { indexSet in
                viewModel.remove(torrents: indexSet.map { filteredTorrents[$0] })
            }
        }
        .toolbar {
            filter
        }
        #if os(iOS)
        .navigationBarTitle("Torrents")
        #endif
    }
    
    private var filter: some View {
        
        Picker("Filter", selection: $selectedFilter) {
            ForEach(TorrentState.allCases) { filter in
                switch filter {
                case .downloading:
                    Text("Downloading")
                    
                case .seeding:
                    Text("Seeding")
                    
                case .queued:
                    Text("Queued")
                    
                case .paused:
                    Text("Paused")
                
                case .error:
                    Text("Error")
                }
            }
        }
        .padding(.vertical)
    }
}

struct TorrentsListView_Previews: PreviewProvider {
    
    static var previews: some View {
       
        return NavigationView {
            TorrentListView(viewModel: .init(client: .init(endpoint: URL(string: "http://google.com")!, password: "")))
        }
    }
}

