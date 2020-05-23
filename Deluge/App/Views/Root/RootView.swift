//
//  RootView.swift
//  Deluge
//
//  Created by Emil Landron on 5/4/20.
//  Copyright © 2020 Emil Landron. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var store: AppStore

    var body: some View {
        
        var signInView: SignInView?
        var torrentList: NavigationView<TorrentListView>?
        
        switch store.state.signInState {
        case .signingIn, .signout:
            signInView = SignInView()

        case .signedIn:
            torrentList = NavigationView { TorrentListView() }
        }
        
        return Group {
            signInView
            torrentList
        }
        .onAppear {
            print("Yala")
            self.store.send(StartupAction())
        }
    }
}

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView()
    }
}
