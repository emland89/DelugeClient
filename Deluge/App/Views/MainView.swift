//
//  MainView.swift
//  Deluge
//
//  Created by Emil Landron on 5/22/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        
        TabView {
            NavigationView {
                TorrentListView(viewModel: viewModel.listViewModel)
            }
            .tabItem {
                Text("Torrents")
                Image(systemName: "list.dash")
            }
            .tag(0)
            
            NavigationView {
                Button("Signout") {
                   // self.store.send(SignOutAction())
                }
            }
            .tabItem {
                Text("Client")
                Image(systemName: "drop.triangle")
            }
            .tag(1)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView(viewModel: .init(client: .init(endpoint: URL(string: "")!, password: "")))
    }
}
