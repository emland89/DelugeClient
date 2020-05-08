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
                ForEach(self.viewModel.torrents) { torrent in
                    TorrentListItemView(torrent: torrent)
                }
            }
        
        .navigationBarTitle("Torrents")
        
    }
}

struct TorrentsListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        return NavigationView {
            TorrentListView(viewModel: .init())
            
        }
    }
}
