//
//  MainView.swift
//  Deluge
//
//  Created by Emil Landron on 5/22/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    var viewModel: MainViewModel
    
    var body: some View {
        
        TabView {
            NavigationStack {
                TorrentListView(viewModel: viewModel.listViewModel)
            }
            .tabItem {
                Text("Torrents")
                Image(systemName: "list.dash")
            }
            .tag(0)
            
            NavigationStack {
                Button("Signout") {
                   // self.store.send(SignOutAction())
                }
            }
            .tabItem {
                Text("Settings")
                Image(systemName: "cog")
            }
            .tag(1)
        }
        .onOpenURL { link in
            viewModel.addMagnet(link: link)
        }
    }
}

#Preview {
    MainView(viewModel: .init(client: .init(endpoint: URL(string: "google.com")!, password: "")))
}
