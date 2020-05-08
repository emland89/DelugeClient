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
    
    var body: some View {
        
        List {
            Section(header: filter) {
                ForEach(self.viewModel.torrents) { torrent in
                    TorrentListItemView(torrent: torrent)
                        .padding(.vertical, 6)
                        .contextMenu {
                            Button("Resume", action: { self.viewModel.resume(torrent) })
                            Button("Pause", action: { self.viewModel.pause(torrent) })
                            Divider()
                            Button("Top", action: { self.viewModel.top(torrent) })
                            Button("Up", action: { self.viewModel.up(torrent) })
                            Button("Down", action: { self.viewModel.down(torrent) })
                            Button("Bottom", action: { self.viewModel.bottom(torrent) })
                    }
                }
            }
        }
        .navigationBarTitle("Torrents")
        .onAppear(perform: viewModel.setup)
    }
    
    private var filter: some View {
        
        Picker(selection: $viewModel.selectedFilter, label: EmptyView()) {
            
            ForEach(viewModel.filters) { filter -> Text in
                
                switch filter {
                case .downloading:
                    return Text("Downloading")
                    
                case .seeding:
                    return Text("Seeding")
                    
                case .queued:
                    return Text("Queued")
                    
                case .paused:
                    return Text("Paused")
                }
                
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.vertical)
    }
}

struct TorrentsListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let credentials = Credentials(endpoint: URL(string: "")!, password: "")
        let client = DelugeClient(credentials: credentials)
       
        return NavigationView {
            TorrentListView(viewModel: .init(client: client))
        }
    }
}
