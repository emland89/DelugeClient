//
//  TorrentsListView.swift
//  Deluge
//
//  Created by Emil Landron on 5/5/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct TorrentListView: View {
    
    @EnvironmentObject var store: AppStore

    var body: some View {
        
        List {
            Section(header: filter) {
                ForEach(self.store.state.filteredTorrents) { torrent in
                    TorrentListItemView(torrent: torrent)
                        .padding(.vertical, 6)
                        .contextMenu {
                            Button("Resume", action: { self.setQueue(action: .resume, for: torrent) })
                            Button("Pause", action: {  self.setQueue(action: .pause, for: torrent)})
                            Divider()
                            Button("Top", action: {  self.setQueue(action: .top, for: torrent) })
                            Button("Up", action: {  self.setQueue(action: .up, for: torrent) })
                            Button("Down", action: {  self.setQueue(action: .down, for: torrent) })
                            Button("Bottom", action: { self.setQueue(action: .bottom, for: torrent) })
                    }
                }
            }
        }
        .onAppear(perform: {
            self.store.send(StartFetchTorrentsAction())
        })
        .navigationBarTitle("Torrents")
    }
    
    private var filter: some View {
        
        Picker(selection: store.binding(for: \.selectedFilter, toAction: { filter in
            ChangeFilterAction(filter: filter)
        }), label: EmptyView()) {
            
            ForEach(store.state.filters) { filter -> Text in
                
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
    
    private func setQueue(action: TorrentQueueAction.Action, for torrents: Torrent...) {
        self.store.send(TorrentQueueAction(action: action, torrents: torrents))
    }
}

struct TorrentsListView_Previews: PreviewProvider {
    
    static var previews: some View {
       
        return NavigationView {
            TorrentListView()
                .environmentObject(store)
        }
    }
}

