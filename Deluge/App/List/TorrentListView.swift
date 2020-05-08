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
                case .all:
                    return Text("All")

                case .downloading:
                    return Text("Downloading")
                    
                case .seeding:
                    return Text("Seeding")
                    
                case .queued:
                    return Text("Queued")
                }
                
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.vertical)
    }
}

struct TorrentsListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        return NavigationView {
            TorrentListView(viewModel: .init(credentials: .init(endpoint: URL(string: "")!, password: "")))
        }
    }
}
