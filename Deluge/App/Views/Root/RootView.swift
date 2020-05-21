//
//  RootView.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @ObservedObject var viewModel: RootViewModel
    
    var body: some View {
        
        var signInView: SignInView?
        var torrentList: NavigationView<TorrentListView>?
        
        switch viewModel.attached {
        case .signIn(let viewModel):
            signInView = SignInView(viewModel: viewModel)
            
        case .torrentList(let viewModel):
            torrentList = NavigationView { TorrentListView(viewModel: viewModel) }
            
        case .none:
            break
        }
        
        return Group {
            signInView
            torrentList
        }
        .onAppear(perform: viewModel.setup)
    }
}

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView(viewModel: .init(store: store))
    }
}
